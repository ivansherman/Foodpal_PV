class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :city
      t.string :address

      t.timestamps
    end
    add_index :addresses, :city_id
  end
end
