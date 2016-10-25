class ProductsController < SeedController
  private
    def seed_params
      params.require(:product).permit(:created_at, :updated_at, *generic_fields, seeds: [])
    end
end
