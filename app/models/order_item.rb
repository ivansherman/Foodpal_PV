class OrderItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :order
  attr_accessible :count, :product_id

 def  restaurant
   product.menu.restaurant

 end

  def product_price
    product.price
  end
end
