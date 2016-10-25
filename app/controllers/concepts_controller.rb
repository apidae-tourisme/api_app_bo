class ConceptsController < SeedController
  private
    def seed_params
      params.require(:concept).permit(:created_at, :updated_at, *generic_fields, seeds: [])
    end
end
