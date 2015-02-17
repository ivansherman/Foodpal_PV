class RenameCategoryIdToMenuId < ActiveRecord::Migration
  def change
    rename_column :products, :category_id, :menu_id
  end
end
