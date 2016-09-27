json.extract! project, :id, :created_at, :updated_at, :name, :description, :start_date, :end_date, :url, :thumbnail, :created_at, :updated_at
json.url project_url(project, format: :json)