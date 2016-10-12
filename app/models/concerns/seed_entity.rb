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

    before_create :set_creation_timestamp
    before_save :set_update_timestamp

    def label
      self.class.to_s
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
  end
end
