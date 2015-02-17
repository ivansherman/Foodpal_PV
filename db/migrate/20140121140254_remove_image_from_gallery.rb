class RemoveImageFromGallery < ActiveRecord::Migration
  def change
    remove_column :galleries, :image
    add_attachment :galleries, :image
  end

end
