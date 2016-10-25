class EventsController < SeedController
  private
    def seed_params
      params.require(:event).permit(:created_at, :updated_at, *generic_fields, seeds: [])
    end
end
