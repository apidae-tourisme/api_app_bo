class Organization 
  include SeedEntity

  property :address, type: String
  property :email, type: String
  property :telephone, type: String
  property :latitude, type: BigDecimal
  property :longitude, type: BigDecimal
  property :url, type: String

  # has_many :in, :persons, origin: :person
  # has_many :in, :products, origin: :product
  # has_many :in, :competences, origin: :competence
  # has_many :out, :concepts, type: :concepts

end
