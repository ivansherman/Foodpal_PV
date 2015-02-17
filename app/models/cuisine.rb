class Cuisine < ActiveRecord::Base
  #has_and_belongs_to_many :restaurants
  belongs_to :restaurant
  attr_accessible :name, :references, :restaurant_id
  scope :uniquely_named, group(:name)

end
