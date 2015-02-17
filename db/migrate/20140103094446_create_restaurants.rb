class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.text :description
      t.string :logo
      t.integer :delivery_type
      t.integer :payment_type
      t.string :facebook_url
      t.string :twitter_url
      t.string :g_url
      t.string :miny_order
      t.string :tags
      t.boolean :active
      t.datetime :entry_date
      t.string :email
      t.references :user

      t.timestamps
    end
    add_index :restaurants, :user_id
  end
end
