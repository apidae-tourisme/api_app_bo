i = 0
json.nodes do
  json.array! @seeds do |seed|
    if i == 0
      json.merge! seed.visible_fields
      json.is_root true
      i += 1
    else
      json.partial! partial: 'seed', locals: {seed: seed}
      json.is_root false
    end
  end
end
json.links do
  json.array! @links do |l|
    json.extract! l, :source, :target
  end
end