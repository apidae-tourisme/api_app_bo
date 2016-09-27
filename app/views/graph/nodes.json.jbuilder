json.nodes do
  json.array! @nodes, partial: 'graph/seed', as: :seed
end