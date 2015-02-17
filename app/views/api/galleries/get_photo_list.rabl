collection :@gallery

attributes :id, :restaurant_id


node :image do |photo|
   photo.image.url(:original)
end

node :image_thumb do |photo|
   photo.image.url(:thumb)
end
