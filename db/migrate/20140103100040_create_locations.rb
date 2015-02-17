class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.references :restaurant
      t.string :branch
      t.string :address
      t.references :city
      t.string :phone
      t.string :delivery_fee
      t.string :delivery_time
      t.string :latitude
      t.string :longitude

      t.timestamps
    end
    add_index :locations, :restaurant_id
    add_index :locations, :city_id
  end
end
