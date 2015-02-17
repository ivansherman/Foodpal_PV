class RemoveColumnStatusFromOrder < ActiveRecord::Migration
  def change
    remove_column :orders, :status

    add_column :orders, :status_id, :string
  end

end
