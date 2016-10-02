json.seeds do
  json.array! @seeds do |s|
    json.text s.name
    json.id s.id
  end
end