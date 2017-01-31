json.node do
  json.merge! @seed.visible_fields
  json.author @author.name if @author
end
