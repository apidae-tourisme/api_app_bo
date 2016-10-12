class OrganizationsController < SeedController
  private
    def seed_params
      params.require(:organization).permit(:created_at, :updated_at, :name, :description, :address, :email,
                                           :telephone, :thumbnail, :latitude, :longitude, :url, seeds: [])
    end
end
