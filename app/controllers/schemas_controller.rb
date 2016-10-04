class SchemasController < SeedController
  private
    def seed_params
      params.require(:schema).permit(:created_at, :updated_at, :name, :description, :thumbnail)
    end
end
