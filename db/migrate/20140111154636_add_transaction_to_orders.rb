class AddTransactionToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :transaction_id, :integer
  end
end
