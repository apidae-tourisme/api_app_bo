class TasksController < SeedController
  private
    def seed_params
      params.require(:task).permit(:created_at, :updated_at, {urls: []}, {seeds: []}, *generic_fields)
    end
end
