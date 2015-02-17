class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart
  attr_accessible :cart_id, :product_id, :quantity

  def product_price
    product.price
  end

  def  restaurant
    product.menu.restaurant

  end


end
