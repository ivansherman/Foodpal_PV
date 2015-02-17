class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :iso2
      t.string :iso3
      t.string :short_name
      t.string :long_name
      t.integer :num_code
      t.string :un_member
      t.string :calling_code
      t.string :cctld

      t.timestamps
    end
  end
end
