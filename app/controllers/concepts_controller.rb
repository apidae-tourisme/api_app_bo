class ConceptsController < SeedController
  private
    def seed_params
      params.require(:concept).permit(:created_at, :updated_at, :name, :description, :thumbnail, seeds: [])
    end
end
