class CreateCusines < ActiveRecord::Migration
  def change
    create_table :cusines do |t|
      t.string :cusine
      t.references :restaurant

      t.timestamps
    end
    add_index :cusines, :restaurant_id
  end
end
