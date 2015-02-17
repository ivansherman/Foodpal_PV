class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.references :country
      t.string :state
      t.string :state_code

      t.timestamps
    end
    add_index :states, :country_id
  end
end
