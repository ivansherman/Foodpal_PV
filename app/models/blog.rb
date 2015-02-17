class Blog < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  attr_accessible :text, :title
end
