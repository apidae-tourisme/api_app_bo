class IdeasController < SeedController
  private
    def seed_params
      params.require(:idea).permit(:created_at, :updated_at, :name, :description, :thumbnail)
    end
end
