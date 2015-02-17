class AddRestaurantIdToCuisine < ActiveRecord::Migration
  def change
    add_column :cuisines, :restaurant_id, :integer
  end
end
