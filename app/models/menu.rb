class Menu < ActiveRecord::Base
  belongs_to :restaurant
  has_many :products, dependent: :destroy

  attr_accessible :description, :end_time, :name, :start_time, :restaurant_id
end
