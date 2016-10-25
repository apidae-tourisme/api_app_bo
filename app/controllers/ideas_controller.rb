class IdeasController < SeedController
  private
    def seed_params
      params.require(:idea).permit(:created_at, :updated_at, *generic_fields, seeds: [])
    end
end
