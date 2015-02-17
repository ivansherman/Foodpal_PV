class AddListToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :list, :boolean
  end
end
