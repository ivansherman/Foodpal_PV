class Product < ActiveRecord::Base
  has_many :line_items
  belongs_to :menu
  belongs_to :category

  def self.restaurant
    menu.restaurant


  end


  attr_accessible :description, :name, :picture, :image, :price, :menu_id

  has_attached_file :image,
                    :url  => "/uploads/images/products/:id/:style/:filename.:extension",
                    :default_url => "/assets/imagenotavailable.png",
                    :path => ":rails_root/public/uploads/images/products/:id/:style/:filename.:extension",
                    :styles => { :medium => "300x300>", :thumb => "100x100>" }

  before_destroy :ensure_not_referehced_by_any_line_item

  private

  def ensure_not_referehced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base,'this product is in some cart')
      return false
    end

  end

end
