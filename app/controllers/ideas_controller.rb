class IdeasController < SeedController
  private
    def seed_params
      params.require(:idea).permit(:created_at, :updated_at, {urls: []}, {seeds: []}, *generic_fields)
    end
end
