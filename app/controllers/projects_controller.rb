class ProjectsController < SeedController
  private
  def seed_params
    params.require(:project).permit(:created_at, :updated_at, :name, :description, :start_date, :end_date, :url,
                                    :thumbnail, seeds: [])
  end
end
