class Order < ActiveRecord::Base
  belongs_to :user
  has_many :order_items
  belongs_to :location
  belongs_to :status



  attr_accessible :delivery_type, :payment_method, :statys, :totalprice, :phone, :instructions, :napkins, :condiments, :delivery_date, :delivery_time, :transaction_id, :address, :location_id, :status_id, :success_key, :cancel_key
end
