class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string :name
      t.references :restaurant
      t.string :start_time
      t.string :end_time
      t.text :description

      t.timestamps
    end
    add_index :menus, :restaurant_id
  end
end
