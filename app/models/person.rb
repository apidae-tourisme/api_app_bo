class Person 
  include SeedEntity

  property :firstname, type: String
  property :lastname, type: String
  property :role, type: String
  property :email, type: String
  property :telephone, type: String
  property :mobilephone, type: String

  # has_many :out, :organizations, type: :employed_by
  # has_many :out, :projects, type: :involved_in
  # has_many :out, :competences, type: :skilled_for
  # has_many :out, :products, type: :works_on
  # has_many :out, :concepts, type: :concepts
  # has_many :out, :ideas, origin: :initiator
end
