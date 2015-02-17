class RenameCusineToName < ActiveRecord::Migration
  def change
    rename_column :cusines, :cusine, :name
    rename_table :cusines, :cuisines
  end

end
