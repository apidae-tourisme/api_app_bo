class EventsController < SeedController
  private
    def seed_params
      params.require(:event).permit(:created_at, :updated_at, :name, :description, :reference, :thumbnail, seeds: [])
    end
end
