class ChangeTagsToTax < ActiveRecord::Migration
  def change
    rename_column :restaurants, :tags, :tax
  end
end
