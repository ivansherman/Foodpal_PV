class Location < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :state
  belongs_to :city
  has_many :orders
  delegate :latitude, :longitude,  to: :restaurant, prefix: true


  attr_accessible :address, :branch, :delivery_fee, :delivery_time, :latitude, :longitude, :phone, :city_id, :restaurant_id, :zip


  def restaurant_id
    restaurant.id
  end

  def my_restaurant(user)
     restaurant.user == user || user.role?(:admin)
  end
end
