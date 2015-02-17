class Address < ActiveRecord::Base
  belongs_to :city
  belongs_to :user
  attr_accessible :address, :city_id
end
