class CreativeWorksController < SeedController
  private
    def seed_params
      params.require(:creative_work).permit(:created_at, :updated_at, {urls: []}, {seeds: []}, *generic_fields)
    end
end
