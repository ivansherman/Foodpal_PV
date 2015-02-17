class RenameRestaurantIdToLocationIdInOrders < ActiveRecord::Migration
  def change
    rename_column :orders, :restaurant_id, :location_id
  end
end
