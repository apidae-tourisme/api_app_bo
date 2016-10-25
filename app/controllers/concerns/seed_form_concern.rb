module SeedFormConcern
  extend ActiveSupport::Concern

  def form_fields(seed_fields)
    (generic_fields + seed_fields).uniq
  end

  def generic_fields
    [:name, :description, :thumbnail, :url, :latitude, :longitude, :started_at, :ended_at]
  end
end