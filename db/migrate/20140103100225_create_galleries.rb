class CreateGalleries < ActiveRecord::Migration
  def change
    create_table :galleries do |t|
      t.references :restourant
      t.string :title
      t.string :image
      t.string :photo_order

      t.timestamps
    end
    add_index :galleries, :restourant_id
  end
end
