class Gallery < ActiveRecord::Base
  belongs_to :restaurant
  attr_accessible :image, :restaurant_id
  has_attached_file :image,
                    :url  => "/uploads/images/gallery/:id/:style/:filename.:extension",
                    :default_url => "/assets/imagenotavailable.png",
                    :path => ":rails_root/public/uploads/images/gallery/:id/:style/:filename.:extension",
                    :styles => { :medium => "300x300>", :thumb => "150x150>" }
end
