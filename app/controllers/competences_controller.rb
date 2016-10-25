class CompetencesController < SeedController
  private
    def seed_params
      params.require(:competence).permit(:created_at, :updated_at, *generic_fields, seeds: [])
    end
end
