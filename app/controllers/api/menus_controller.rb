class Api::MenusController < ApplicationController
  before_filter :api_authentikate_user, except: [:get_menu_list]

  def get_menu_list
    restaurant = Restaurant.find_by_id(params[:rest_id])
    @menu = restaurant.menus

  end
end