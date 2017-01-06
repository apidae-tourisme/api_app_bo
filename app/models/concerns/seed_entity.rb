module SeedEntity
  extend ActiveSupport::Concern

  include Neo4j::ActiveNode

  SCOPE_PRIVATE = 'private'
  SCOPE_PUBLIC = 'public'

  included do
    property :created_at, type: Integer
    property :updated_at, type: Integer
    property :reference, type: String, index: :exact
    property :name, type: String
    property :description, type: String
    property :thumbnail, type: String
    property :url, type: String
    property :latitude, type: BigDecimal
    property :longitude, type: BigDecimal
    property :start_date, type: Integer
    property :end_date, type: Integer
    property :scope, type: String, index: :exact
    property :last_contributor, type: String
    property :urls
    property :history

    serialize :urls
    serialize :history

    has_many :both, :connected_seeds, type: false, model_class: false

    before_create :set_creation_timestamp
    before_save :set_update_timestamp

    def visible_seeds(user)
      connected_seeds(:n)
          .where("n.scope = {public} OR n.scope IS NULL OR (n.scope = {private} AND n.last_contributor = {author})")
          .params({public: SeedEntity::SCOPE_PUBLIC, private: SeedEntity::SCOPE_PRIVATE, author: user.email})
    end

    def visible_fields
      attributes.
          except('provider', 'tokens', 'current_sign_in_at', 'current_sign_in_ip', 'last_sign_in_at', 'last_sign_in_ip',
                 'sign_in_count', 'encrypted_password', 'history').
          merge({'label' => label, 'id' => id, 'urls' => urls, 'last_contributor' => last_contributor})
    end

    def label
      self.is_a?(Task) ? 'Action' : self.class.to_s
    end

    def seeds
      connected_seeds.collect {|s| s.id}
    end

    def seeds=(val)
      if val && val.is_a?(Array)
        new_seeds = Neo4j::Session.current.query.match(:n).where('n.uuid' => val.select {|v| !v.blank?}).return(:n).
            collect {|res| res.n}
        self.connected_seeds = new_seeds
      end
    end

    def set_creation_timestamp
      self.created_at = Time.current.to_i
    end

    def set_update_timestamp
      self.updated_at = Time.current.to_i
    end

    def creation_date
      Time.at(self.created_at)
    end

    def started_at
      Time.at(start_date) unless start_date.nil?
    end

    def started_at=(val)
      self.start_date = val.nil? ? nil : Time.parse(val).to_i
    end

    def ended_at
      Time.at(end_date) unless end_date.nil?
    end

    def ended_at=(val)
      self.end_date = val.nil? ? nil : Time.parse(val).to_i
    end

    def log_entry(user)
      self.history ||= []
      self.history += [{'author' => user, 'timestamp' => Time.current.to_i, 'changes' => self.changes.except(:history)}]
      self.last_contributor = self.history.sort_by {|h| h['timestamp']}.last['author'] unless self.history.blank?
    end
  end
end
