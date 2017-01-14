class EventsController < SeedController
  private
    def seed_params
      params.require(:event).permit(:created_at, :updated_at, {urls: []}, {seeds: []}, *generic_fields)
    end
end
