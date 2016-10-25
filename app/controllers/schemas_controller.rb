class SchemasController < SeedController
  private
    def seed_params
      params.require(:schema).permit(:created_at, :updated_at, *generic_fields, seeds: [])
    end
end
