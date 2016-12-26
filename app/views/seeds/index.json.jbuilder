json.nodes do
  json.array! @seeds, partial: 'seeds/seed', as: :seed
end