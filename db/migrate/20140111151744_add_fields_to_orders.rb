class AddFieldsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :phone, :string
    add_column :orders, :instructions, :text
    add_column :orders, :napkins, :boolean
    add_column :orders, :condiments, :boolean
    add_column :orders, :delivery_date, :string
    add_column :orders, :delivery_time, :string
    add_column :orders, :cash, :boolean
    change_column :orders, :delivery_type, :boolean
  end
end
