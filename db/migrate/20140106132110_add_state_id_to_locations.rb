class AddStateIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :state_id, :integer
  end
end
