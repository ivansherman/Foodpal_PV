class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user
      t.references :restaurant
      t.text :comment

      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, :restaurant_id
  end
end
