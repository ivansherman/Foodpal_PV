class RenameRestourantIdToRestaurantId < ActiveRecord::Migration
  def change
    rename_column :galleries, :restourant_id, :restaurant_id
  end

end
