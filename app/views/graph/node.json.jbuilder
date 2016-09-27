json.nodes do
  json.array! @nodes, partial: 'graph/seed', as: :seed
end
json.links do
  json.array! @links do |l|
    json.extract! l, :source, :target
  end
end