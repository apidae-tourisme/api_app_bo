class Person
  include SeedEntity
  include Neo4j::Shared::MassAssignment

  devise :database_authenticatable, :trackable, :omniauthable, :omniauth_providers => [:apidae]

  property :firstname, type: String
  property :lastname, type: String
  property :role, type: String
  property :email, type: String
  property :telephone, type: String
  property :mobilephone, type: String

  # include OAuth concern after Neo4j properties to avoid a name conflict on 'email' property
  include UserConcern

  # Auth-related properties
  property :provider, type: String
  property :uid, type: String
  property :tokens, default: '{}'
  property :current_sign_in_at, type: DateTime
  property :current_sign_in_ip, type: String
  property :last_sign_in_at, type: DateTime
  property :last_sign_in_ip, type: String
  property :sign_in_count, type: Integer
  property :encrypted_password, type: String

  serialize :tokens

  # has_many :out, :organizations, type: :employed_by
  # has_many :out, :projects, type: :involved_in
  # has_many :out, :competences, type: :skilled_for
  # has_many :out, :products, type: :works_on
  # has_many :out, :concepts, type: :concepts
  # has_many :out, :ideas, origin: :initiator
end
