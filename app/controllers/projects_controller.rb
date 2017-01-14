class ProjectsController < SeedController
  private
  def seed_params
    params.require(:project).permit(:created_at, :updated_at, {urls: []}, {seeds: []}, *generic_fields)
  end
end
