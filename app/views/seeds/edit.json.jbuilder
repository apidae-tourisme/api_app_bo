json.node do
  json.merge! @seed.visible_fields
  json.seeds @seed.connected_seeds.collect {|s| {id: s.id, name: s.name, label: s.label, thumbnail: s.thumbnail}}
end
