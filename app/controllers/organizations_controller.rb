class OrganizationsController < SeedController
  private
    def seed_params
      params.require(:organization).permit(:created_at, :updated_at, *generic_fields, :address, :email, :telephone, seeds: [])
    end
end
