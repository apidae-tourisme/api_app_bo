json.extract! seed, :id, :name, :label, :reference, :description, :thumbnail, :scope, :last_contributor
if seed.is_a?(Person)
  json.firstname seed.firstname
  json.lastname seed.lastname
end
