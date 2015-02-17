class AddSessionIdToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :session_id, :integer
  end
end
