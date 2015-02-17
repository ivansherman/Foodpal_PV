class Api::ProductsController < ApplicationController
  before_filter :api_authentikate_user, except: [:get_product_list]

  def get_product_list
    menu = Menu.find_by_id(params[:menu_id])
    @products = menu.products

  end
end