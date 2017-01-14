class ConceptsController < SeedController
  private
    def seed_params
      params.require(:concept).permit(:created_at, :updated_at, {urls: []}, {seeds: []}, *generic_fields)
    end
end
