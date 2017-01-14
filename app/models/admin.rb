class Admin
  include Neo4j::ActiveNode

  property :created_at, type: DateTime
  property :updated_at, type: DateTime
  property :email, type: String, null: false, default: ""
  index :email
  property :encrypted_password

  property :sign_in_count, type: Integer, default: 0
  property :current_sign_in_at, type: DateTime
  property :last_sign_in_at, type: DateTime
  property :current_sign_in_ip, type: String
  property :last_sign_in_ip, type: String

  devise :database_authenticatable, :trackable, :timeoutable
end
