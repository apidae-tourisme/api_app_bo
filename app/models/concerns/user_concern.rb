require 'bcrypt'

# Derived from DeviseTokenAuth User concern - Patched for Neo4j support
module UserConcern
  extend ActiveSupport::Concern

  def self.tokens_match?(token_hash, token)
    @token_equality_cache ||= {}

    key = "#{token_hash}/#{token}"
    result = @token_equality_cache[key] ||= (::BCrypt::Password.new(token_hash) == token)
    if @token_equality_cache.size > 10000
      @token_equality_cache = {}
    end
    result
  end

  included do

    # Hack to check if devise is already enabled
    unless self.method_defined?(:devise_modules)
      devise :database_authenticatable, :registerable,
             :recoverable, :trackable, :validatable, :confirmable
    else
      self.devise_modules.delete(:omniauthable)
    end

    # get rid of dead tokens
    before_save :destroy_expired_tokens

    validates :email, presence: true, email: true, if: Proc.new { |u| u.provider == 'apidae' }
    validates_presence_of :uid, if: Proc.new { |u| u.provider == 'apidae' }
    validate :unique_email_user

    # before_save :sync_uid
    # before_create :sync_uid

    # allows user to change password without current_password
    attr_writer :allow_password_change
    def allow_password_change
      @allow_password_change || false
    end

    # don't use default devise email validation
    def email_required?
      false
    end

    def email_changed?
      false
    end

    def unique_email_user
      if provider == 'apidae' and self.class.where(provider: 'apidae', email: email).count > 0
        errors.add(:email, I18n.t('errors.messages.already_in_use'))
      end
    end

    def sync_uid
      self.uid = email if provider == 'apidae'
    end
  end

  def valid_token?(token, client_id='default')
    client_id ||= 'default'

    return false unless self.tokens[client_id]

    return true if token_is_current?(token, client_id)
    return true if token_can_be_reused?(token, client_id)

    # return false if none of the above conditions are met
    return false
  end

  def token_is_current?(token, client_id)
    # ghetto HashWithIndifferentAccess
    expiry     = self.tokens[client_id]['expiry'] || self.tokens[client_id][:expiry]
    token_hash = self.tokens[client_id]['token'] || self.tokens[client_id][:token]

    return true if (
        # ensure that expiry and token are set
    expiry and token and

        # ensure that the token has not yet expired
        DateTime.strptime(expiry.to_s, '%s') > Time.now and

        # ensure that the token is valid
        DeviseTokenAuth::Concerns::User.tokens_match?(token_hash, token)
    )
  end


  # allow batch requests to use the previous token
  def token_can_be_reused?(token, client_id)
    # ghetto HashWithIndifferentAccess
    updated_at = self.tokens[client_id]['updated_at'] || self.tokens[client_id][:updated_at]
    last_token = self.tokens[client_id]['last_token'] || self.tokens[client_id][:last_token]


    return true if (
        # ensure that the last token and its creation time exist
    updated_at and last_token and

        # ensure that previous token falls within the batch buffer throttle time of the last request
        Time.parse(updated_at) > Time.now - DeviseTokenAuth.batch_request_buffer_throttle and

        # ensure that the token is valid
        ::BCrypt::Password.new(last_token) == token
    )
  end


  # update user's auth token (should happen on each request)
  def create_new_auth_token(client_id=nil)
    client_id  ||= SecureRandom.urlsafe_base64(nil, false)
    last_token ||= nil
    token        = SecureRandom.urlsafe_base64(nil, false)
    token_hash   = ::BCrypt::Password.create(token)
    expiry       = (Time.now + DeviseTokenAuth.token_lifespan).to_i

    if self.tokens[client_id] and self.tokens[client_id]['token']
      last_token = self.tokens[client_id]['token']
    end

    self.tokens[client_id] = {
        token:      token_hash,
        expiry:     expiry,
        last_token: last_token,
        updated_at: Time.now
    }

    return build_auth_header(token, client_id)
  end


  def build_auth_header(token, client_id='default')
    client_id ||= 'default'

    # client may use expiry to prevent validation request if expired
    # must be cast as string or headers will break
    expiry = self.tokens[client_id]['expiry'] || self.tokens[client_id][:expiry]

    max_clients = DeviseTokenAuth.max_number_of_devices
    while self.tokens.keys.length > 0 and max_clients < self.tokens.keys.length
      oldest_token = self.tokens.min_by { |cid, v| v[:expiry] || v["expiry"] }
      self.tokens.delete(oldest_token.first)
    end

    self.save!

    return {
        DeviseTokenAuth.headers_names[:"access-token"] => token,
        DeviseTokenAuth.headers_names[:"token-type"]   => "Bearer",
        DeviseTokenAuth.headers_names[:"client"]       => client_id,
        DeviseTokenAuth.headers_names[:"expiry"]       => expiry.to_s,
        DeviseTokenAuth.headers_names[:"uid"]          => self.uid
    }
  end


  def build_auth_url(base_url, args)
    args[:uid]    = self.uid
    args[:expiry] = self.tokens[args[:client_id]]['expiry']

    DeviseTokenAuth::Url.generate(base_url, args)
  end


  def extend_batch_buffer(token, client_id)
    self.tokens[client_id]['updated_at'] = Time.now

    return build_auth_header(token, client_id)
  end

  def confirmed?
    self.devise_modules.exclude?(:confirmable) || super
  end

  def token_validation_response
    self.as_json(except: [
        :tokens, :created_at, :updated_at
    ])
  end

  def destroy_expired_tokens
    if self.tokens
      self.tokens.delete_if do |cid, v|
        expiry = v[:expiry] || v["expiry"]
        DateTime.strptime(expiry.to_s, '%s') < Time.now
      end
    end
  end

end
