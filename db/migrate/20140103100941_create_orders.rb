class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user
      t.string :totalprice
      t.integer :delivery_type
      t.string :statys
      t.integer :payment_method

      t.timestamps
    end
    add_index :orders, :user_id
  end
end
