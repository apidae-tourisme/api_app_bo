class Product 
  include SeedEntity

  property :url, type: String

  # has_many :in, :persons, origin: :person
  # has_many :out, :projects, type: :projects
  # has_many :out, :organizations, type: :organizations
  # has_many :out, :concepts, type: :concepts

end
