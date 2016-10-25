class PersonsController < SeedController
  private
    def seed_params
      params.require(:person).permit(:created_at, :updated_at, *generic_fields, :firstname,
                                     :lastname, :role, :email, :telephone, :mobilephone, seeds: [])
    end
end
