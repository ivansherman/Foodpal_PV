collection :@locations

attributes :latitude, :longitude, :address, :zip

node :id do |location|
   location.restaurant.id
end

node :name do |location|
   location.restaurant.name
end

node :rating do |location|
   location.restaurant.rating || 0
end

node :location_id do |location|
   location.id
end

node :description do |location|
   location.restaurant.description || 'This restaurant has any description'
end

node :facebook do |location|
   location.restaurant.facebook_url || ''
end

node :google do |location|
   location.restaurant.g_url || ''
end

node :twitter do |location|
   location.restaurant.twitter_url || ''
end

node :url do |location|
   location.restaurant.url || ''
end

node :miny_order do |location|
   location.restaurant.miny_order || 0
end

node :delivery_fee do |location|
   location.delivery_fee || 0
end

node :logo do |location|
   location.restaurant.image.url(:thumb)
end

node :city do |location|
   location.city.city
end

node :cuisines do |location|
  location.restaurant.cuisines.map{|cuisine| cuisine.name}
end

node :has_gallery do |location|
    location.restaurant.galleries.count > 0
end

node :payment do |p|
    p.restaurant.payment_type
end

node :delivery do |p|
    p.restaurant.delivery_type
end