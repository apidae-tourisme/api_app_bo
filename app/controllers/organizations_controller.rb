class OrganizationsController < SeedController
  private
    def seed_params
      params.require(:organization).permit(:created_at, :updated_at, :email, :telephone, :mobilephone, {urls: []}, {seeds: []},
                                           *generic_fields)
    end
end
