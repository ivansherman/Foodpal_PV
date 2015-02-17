class Api::CommentsController < ApplicationController
  before_filter :api_authentikate_user, except: [:list, :create]

  def create
    #@gallery = Gallery.where(:restaurant_id => params[:rest_id])
    #@gallery = restaurant.menus

  end

  def delete
    #@photo = Gallery.where(:restaurant_id => params[:rest_id]).last
  end

  def list
    @restaurant = Restaurant.find_by_id(params[:restaurantId])
    @comments = @restaurant.comments.reverse
  end

end