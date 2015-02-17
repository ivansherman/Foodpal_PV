class GalleryController < ApplicationController

  def delete

    id = params[:id]
    restaurant = Gallery.find_by_id(id).restaurant
    puts restaurant.inspect.blue

    if (Gallery.find_by_id(id).destroy)


      @restaurant = restaurant
      render partial: "gallery/list_by_restaurant"
    end

  end

  def create
    puts params[:gallery][:restaurant_id].inspect.green.bold
    puts params[:gallery].inspect.light_blue

    #restaurant = Restaurant.find_by_id(params[:restaurant_id])
    #puts restaurant.inspect.green.bold

    #if params[:gallery][:image].present?
    #  params[:gallery][:image].original_filename = "image.jpg"
    #end
    @gallery = Gallery.create(params[:gallery])

    @restaurant = @gallery.restaurant
    render partial: "gallery/list_by_restaurant"
  end

end
