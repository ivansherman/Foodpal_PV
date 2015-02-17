class Api::GalleriesController < ApplicationController
  before_filter :api_authentikate_user, except: [:get_photo_list, :get_first_photo]

  def get_photo_list
    @gallery = Gallery.where(:restaurant_id => params[:rest_id])
    #@gallery = restaurant.menus

  end

  def get_first_photo
    @photo = Gallery.where(:restaurant_id => params[:rest_id]).last
  end
end