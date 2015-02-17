class AddRestaurantIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :restaurant_id, :int
  end
end
