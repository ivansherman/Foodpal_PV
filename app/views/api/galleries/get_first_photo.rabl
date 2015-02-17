collection :@photo

attributes :id, :restaurant_id


node :image do |photo|
   photo.image.url(:original)
end

