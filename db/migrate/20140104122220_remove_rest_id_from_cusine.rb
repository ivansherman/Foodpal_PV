class RemoveRestIdFromCusine < ActiveRecord::Migration
  def change
    remove_column :cusines, :restaurant_id
  end
end
