collection :@products

attributes :id, :name, :description, :menu_id, :price

node :logo do |product|
   product.image.url(:thumb)
end

node :full_logo do |product|
   product.image.url(:original)
end
