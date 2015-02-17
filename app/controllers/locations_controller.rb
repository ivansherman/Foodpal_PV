class LocationsController < ApplicationController

  def list_by_restaurant

  end

  def create
    puts params.inspect.yellow.bold
    puts params[:city].inspect.magenta
    @location = Location.create(params[:location])

    @restaurant = @location.restaurant
    puts @restaurant.inspect.blue.bold

    flash[:success] = "Restaurant created"
    render partial: "locations/list_by_restaurant"
  end

  def get_l_state
    puts params.inspect.magenta.bold
    puts params[:id].inspect.yellow

    if params[:id] != ""
      puts "inside L state with id".green
      l = Location.find_by_id(params[:id])
      puts l.inspect.magenta.bold
      state = l.city.state
      puts state.inspect.red.bold
    else
      puts "inside L state without id".green
      state = State.all
    end


    render json: state
  end

  def get_l_city
    puts params.inspect.magenta.bold

    if params[:id] != ""
      puts "inside L city with id".green
      l = Location.find_by_id(params[:id])
      city = l.city
    else
      puts "inside L city without id".green
      city = State.all
    end


    render json: city
  end

  def select_state
    state = State.find_by_id(params[:id])
    @cities = state.cities.order(:city)

    render json: @cities
  end

  def edit
    if params[:id] != "" && params[:id]
      puts params.inspect.red
      puts params[:id].inspect.green
      location = Location.find_by_id(params[:id])
      restaurant = location.restaurant
    else
      location = Location.new
      restaurant = Restaurant.find_by_id(params[:rest_id])
      puts params[:rest_id].inspect.magenta
    end

    @location = location

    puts restaurant.inspect.green


    render partial: "locations/new", locals: {restaurant: restaurant}
  end


  def update
    puts params.inspect.magenta.bold
    puts params[:location][:id].inspect.blue.bold
    @location = Location.find_by_id(params[:location][:id])
    puts @location.inspect.green
    if @location
      if @location.update_attributes(params[:location])
        puts "OK".yellow
        flash[:success] = "Location updated"
      end

    end

    @restaurant = @location.restaurant
    render partial: "locations/list_by_restaurant"
  end

  def delete
    id = params[:id]
    restaurant = Location.find_by_id(id).restaurant
    puts restaurant.inspect.blue

    if (Location.find_by_id(id).destroy)

      flash[:success] = "Restaurant deleted"
    end

    @restaurant = restaurant
    render partial: "locations/list_by_restaurant"
  end


end
