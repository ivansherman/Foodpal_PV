class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.references :menu

      t.timestamps
    end

    add_index :categories, :menu_id
  end
end
