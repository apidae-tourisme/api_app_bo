json.extract! creative_work, :id, :created_at, :updated_at, :name, :description, :thumbnail, :url, :created_at, :updated_at
json.url creative_work_url(creative_work, format: :json)