class MenusController < ApplicationController
  def create
    puts params.inspect.bold.magenta

    @restaurant = Restaurant.find_by_id(params[:menu][:restaurant_id])
    @menu = Menu.new(params[:menu])

    @product = Product.new

    if @menu.save
      flash[:success] = "Menu added"
      render partial: "menus/list"
    else

      render partial: "menus/list"
    end


  end

  def update
    puts params.inspect.red

    @menu = Menu.find_by_id(params[:menu][:id])
    @restaurant = @menu.restaurant
    @product = Product.new

    if @menu.update_attributes(params[:menu])
      render partial: "menus/list"
    else
      render partial: "menus/list"
    end



  end

  def delete
    @menu = Menu.find_by_id(params[:id])
    @restaurant = @menu.restaurant
    @product = Product.new

    if @menu.destroy
      render partial: "menus/list"
    else
      render partial: "menus/list"
    end

  end

  def edit

    puts params.inspect.green

    @menu = Menu.find_by_id(params[:id])

    @restaurant = @menu.restaurant

    @product = Product.new

    if @menu
      render partial: "menus/edit_and_add"

    else
      flash[:error] = "No item found"
      render partial: "menus/edit_and_add"
    end
  end
end
