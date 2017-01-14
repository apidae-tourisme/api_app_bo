class PersonsController < SeedController
  private
    def seed_params
      params.require(:person).permit(:created_at, :updated_at, :firstname, :lastname, :email, :telephone, :mobilephone,
                                     :active, {urls: []}, {seeds: []}, *generic_fields)
    end
end
