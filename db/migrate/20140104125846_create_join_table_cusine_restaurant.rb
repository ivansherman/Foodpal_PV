class CreateJoinTableCusineRestaurant < ActiveRecord::Migration
  def change
    create_table :cusines_restaurants do |t|
      t.integer :cusine_id
      t.integer :restaurant_id
    end
  end
end
