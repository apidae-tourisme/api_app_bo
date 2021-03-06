class Person
  include Neo4j::ActiveNode
  before_save :update_name

  include SeedEntity
  include Neo4j::Shared::MassAssignment

  devise :database_authenticatable, :trackable, :omniauthable, :omniauth_providers => [:apidae]

  property :firstname, type: String
  property :lastname, type: String
  property :role, type: String
  property :email, type: String
  property :telephone, type: String
  property :mobilephone, type: String
  property :active, type: Integer

  # include OAuth concern after Neo4j properties to avoid a name conflict on 'email' property
  include UserConcern

  # Auth-related properties
  property :provider, type: String
  property :uid, type: String, index: :exact
  property :tokens, default: '{}'
  property :current_sign_in_at, type: DateTime
  property :current_sign_in_ip, type: String
  property :last_sign_in_at, type: DateTime
  property :last_sign_in_ip, type: String
  property :sign_in_count, type: Integer
  property :encrypted_password, type: String

  serialize :tokens

  def update_name
    self.name = "#{self.firstname} #{self.lastname}"
  end
end
