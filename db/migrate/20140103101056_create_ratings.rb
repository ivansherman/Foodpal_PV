class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.references :user
      t.references :restaurant
      t.integer :value

      t.timestamps
    end
    add_index :ratings, :user_id
    add_index :ratings, :restaurant_id
  end
end
