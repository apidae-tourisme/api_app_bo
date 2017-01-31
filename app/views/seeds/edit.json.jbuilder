json.node do
  json.merge! @seed.visible_fields
  if @user
    json.seeds @seed.visible_seeds(@user).collect {|s| {id: s.id, name: s.name, label: s.label, thumbnail: s.thumbnail}}
  end
end
