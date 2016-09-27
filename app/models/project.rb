class Project 
  include SeedEntity

  property :start_date, type: Integer
  property :end_date, type: Integer
  property :url, type: String

  # has_many :in, :persons, origin: :person
  # has_many :in, :products, origin: :product
end
