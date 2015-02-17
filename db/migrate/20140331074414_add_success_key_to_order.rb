class AddSuccessKeyToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :success_key, :string
    add_column :orders, :cancel_key, :string
  end
end
