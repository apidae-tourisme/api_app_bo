class CompetencesController < SeedController
  private
    def seed_params
      params.require(:competence).permit(:created_at, :updated_at, {urls: []}, {seeds: []}, *generic_fields)
    end
end
