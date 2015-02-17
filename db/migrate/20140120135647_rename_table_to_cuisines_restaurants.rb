class RenameTableToCuisinesRestaurants < ActiveRecord::Migration
  def change
    rename_column :cusines_restaurants, :cusine_id, :cuisine_id
    rename_table :cusines_restaurants, :cuisines_restaurants
  end
end
