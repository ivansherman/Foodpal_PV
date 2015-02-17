class Session < ActiveRecord::Base
  belongs_to :user
  has_one :cart
  attr_accessible :auth_token, :user_id, :updated_at
end
