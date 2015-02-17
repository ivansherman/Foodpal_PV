class Status < ActiveRecord::Base
  has_many :orders
  attr_accessible :title
end
