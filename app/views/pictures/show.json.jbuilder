json.picture do
  json.thumbnail image_url(@picture.img.url(:thumb))
end