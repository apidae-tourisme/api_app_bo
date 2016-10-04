class TasksController < SeedController
  private
    def seed_params
      params.require(:task).permit(:created_at, :updated_at, :name, :description, :reference, :thumbnail)
    end
end
