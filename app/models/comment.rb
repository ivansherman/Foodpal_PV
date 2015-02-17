class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :restaurant
  belongs_to :blog
  attr_accessible :comment, :user_id
end
