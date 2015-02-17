class CuisinesController < ApplicationController

  autocomplete :cuisine, :name, :scopes => [:uniquely_named]


  def create

    puts params.inspect.yellow.bold
    params[:cuisine][:name] = params[:cuisine][:name].to_s.downcase
    @cuisine = Cuisine.create(params[:cuisine])

    @restaurant = @cuisine.restaurant

    flash[:success] = "Cousine created"
    render partial: "cuisines/list_by_restaurant"
  end

  def delete
    id = params[:id]
    restaurant = Cuisine.find_by_id(id).restaurant
    puts restaurant.inspect.blue

    if (Cuisine.find_by_id(id).destroy)

      @restaurant = restaurant

      flash[:success] = "Cousine deleted"
      render partial: "cuisines/list_by_restaurant"
    end
  end

end
