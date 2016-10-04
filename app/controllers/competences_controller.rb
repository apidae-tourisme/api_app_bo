class CompetencesController < SeedController
  private
    def seed_params
      params.require(:competence).permit(:created_at, :updated_at, :name, :description, :thumbnail, seeds: [])
    end
end
