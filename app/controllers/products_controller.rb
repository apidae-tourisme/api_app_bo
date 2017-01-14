class ProductsController < SeedController
  private
    def seed_params
      params.require(:product).permit(:created_at, :updated_at, {urls: []}, {seeds: []}, *generic_fields)
    end
end
