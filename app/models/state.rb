class State < ActiveRecord::Base
  has_many :cities
  has_many :locations
  belongs_to :country
  attr_accessible :state, :state_code
end
