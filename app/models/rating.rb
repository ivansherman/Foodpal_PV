class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :restaurant
  attr_accessible :value, :restaurant_id
end
