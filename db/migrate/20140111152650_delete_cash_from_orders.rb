class DeleteCashFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :cash
    change_column :orders, :payment_method, :boolean
  end

end
