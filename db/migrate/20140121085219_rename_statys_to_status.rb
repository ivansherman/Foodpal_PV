class RenameStatysToStatus < ActiveRecord::Migration
  def change
    rename_column :orders, :statys, :status
  end

end
