module SeedEntity
  extend ActiveSupport::Concern

  include Neo4j::ActiveNode

  included do
    property :created_at, type: Integer
    property :updated_at, type: Integer
    property :reference, type: String
    property :name, type: String
    property :description, type: String
    property :thumbnail, type: String

    has_many :both, :connected_seeds, type: false, model_class: false

    def label
      self.class.to_s
    end
  end
end
