class City < ActiveRecord::Base
  has_many :addresses
  belongs_to :state
  has_many :locations
  attr_accessible :city
end
