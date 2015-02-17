class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name

      t.text :description
      t.string :picture
      t.string :price
      t.references :category

      t.timestamps
    end

    add_index :products, :category_id
  end
end
