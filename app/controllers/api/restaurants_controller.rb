class Api::RestaurantsController < ApplicationController
  before_filter :api_authentikate_user, except: [:set_select_params,
                                                 :search_by_params,
                                                 :set_menu,
                                                 :search_restaurants,
                                                 :get_menu_list,
                                                 :get_from_current_location ]

  def search
    puts '----------------restaurant-----------------------'
    puts params
    render json: params


    #$.ajax({
    #           type: 'POST',
    #           url: 'http://localhost:3000/api/restaurants/search',
    #
    #           success: function(data) { console.log(data) },
    #           error: function(data) { console.log(data['responseText']) },
    #
    #           data: {authentication_token: auth_token, params: {name: '122@v.v', cuisine: '11111111',  rating: '3'}},
    #
    #       });
  end

  def show
    puts '----------------restaurant-----------------------'

    render json: params

    #$.ajax({
    #           type: 'GET',
    #           url: 'http://localhost:3000/api/restaurants/show',
    #
    #           success: function(data) { console.log(data) },
    #           error: function(data) { console.log(data['responseText']) },
    #
    #           data: {authentication_token: auth_token, hotel_id: 12},
    #
    #       });
    #puts params

  end

  def menu
    puts '----------------restaurant-----------------------'
    puts params
    render json: params
  end

  def set_select_params
    puts "--------------set---select---params--------------------------------"
    sities = ActiveRecord::Base.connection.select_all("SELECT DISTINCT cities.city  FROM locations, cities, menus WHERE locations.city_id = cities.id AND menus.restaurant_id = locations.restaurant_id")
    sities = sities.map{ |hash| hash.values}.flatten! unless sities.blank?

    cusines = ActiveRecord::Base.connection.select_all(" SELECT DISTINCT cuisines.name FROM  cuisines
       LEFT JOIN restaurants ON (cuisines.restaurant_id= restaurants.id);")
    cusines= cusines.map{ |hash| hash.values}.flatten! unless sities.blank?
    list = {cities: sities, cuisines: cusines }
    puts list.to_s.green.bold
    render json: list.to_json
  end

  def search_by_params
    puts "--------------seach  restaurants--------------------------------"
    puts params.inspect

    city_par = params[:city]
    cuisine = params[:cusine]
    rating = params[:rating]
    keyword = params[:search_parametr]


    puts(city_par == 'City')
    puts(cuisine)
    puts(rating)
    puts(keyword)


    city = (params[:city] && params[:city] != "City" ) ? "AND cities.city = '#{params[:city]}' " : ""
    city2 = (city_par == "City" || !params[:city]) ? "OR cities.city LIKE '%#{keyword}%' OR cities.zip LIKE  '%#{keyword}%'" : ""


    cuisine_val = (cuisine == "Cuisine" || !cuisine) ? "" : "AND (cuisines.`name` LIKE '%#{cuisine}%')"
    cuisine_ref = (cuisine == "Cuisine"  || !cuisine) ? "" : "AND cuisines.restaurant_id = restaurants.id"

    rating_val = (rating == "Rating" || !rating) ? "" : "AND (restaurants.`rating` LIKE '%#{rating}%')"

    puts cuisine_ref.inspect.green.bold
    puts rating_val.inspect.green.bold
    puts city.inspect.yellow.bold
    puts city2.inspect.yellow.bold


    c1 = (cuisine == "Cuisine" || !cuisine) ? "" : "join cuisines cu on cu.restaurant_id = r.id"
    c2 = (cuisine == "Cuisine" || !cuisine) ? "" :"AND cu.`name` LIKE '%#{cuisine}%'"

    r2 = (rating == "Rating" || !rating) ? "" :" AND r.`rating` = #{rating}"

    s_r = "join restaurants r on l.restaurant_id = r.id join cities c on l.city_id = c.id join states s on c.state_id = s.id"
    s_v = "r.name LIKE '%#{keyword}%' OR c.city LIKE '%#{keyword}%' OR l.zip LIKE '%#{keyword}%' OR s.state LIKE '%#{keyword}%' OR s.state_code LIKE '%#{keyword}%'"


    @locations = Location.find_by_sql("SELECT  l.*
    FROM locations l #{s_r}
    #{c1}
    WHERE (#{s_v}
          ) AND
    r.delivery_type in (0, 1) #{c2} #{r2}
    AND ((l.latitude > 0) OR (l.latitude < 0))
    AND ((l.longitude > 0) OR (l.longitude < 0));")

    # @locations = Location.find_by_sql("SELECT DISTINCT
    #                   locations.*
    #                 FROM
    #                   locations,
    #                   restaurants,
    #                  cities,
    #                   states,
    #                   cuisines
    #                 WHERE
    #                   locations.restaurant_id = restaurants.id
    #                   AND locations.city_id = cities.id
    #                   AND cities.state_id = states.id
    #                   #{cuisine_ref}
    #                 AND (
    #                   restaurants.name LIKE '%#{keyword}%'
    #                   OR states.state LIKE '%#{keyword}%'
    #                   OR states.state_code LIKE '%#{keyword}%'
    #                   #{city2}
    #                 ) #{cuisine_val}
    #                                   #{rating_val}
    #                                   #{city}"
    #
    # )








    #@locations = Location.find_by_sql("SELECT DISTINCT
    #                  locations.*
    #                FROM
    #                  locations,
    #                  restaurants,
    #                 cities,
    #                  states,
    #                  cuisines
    #                WHERE
    #                  locations.restaurant_id = restaurants.id
    #                  AND locations.city_id = cities.id
    #                  AND cities.state_id = states.id
    #
    #                AND (
    #                  restaurants.name LIKE '%#{search_parametr}%'
    #                  OR cities.city LIKE '%#{search_parametr}%'
    #                  OR cities.zip LIKE  '%#{search_parametr}%'
    #                  OR states.state LIKE '%#{search_parametr}%'
    #                  OR states.state_code LIKE '%#{search_parametr}%'
    #                ) "
    #)




      if @locations.nil?

        render json: {locations: []}.to_json
      end

  end

  def search_restaurants
    puts "--------------seach  restaurants--------------------------------"
    puts params.inspect

    keyword = params[:keyword]
    city = (params[:city] != "" && params[:city]) ? "AND cities.city = '#{params[:city]}' " : ""
    city2 = (params[:city] == "" || !params[:city]) ? "OR cities.city LIKE '%#{keyword}%' OR cities.zip LIKE  '%#{keyword}%'" : ""
    cuisine = params[:cuisine]
    rating = params[:rating]

    cuisine_val = (cuisine == "" || !cuisine) ? "" : "AND (cuisines.`name` LIKE '%#{cuisine}%')"
    cuisine_ref = (cuisine == ""  || !cuisine) ? "" : "AND cuisines.restaurant_id = restaurants.id"

    rating_val = (rating == "" || !rating) ? "" : "AND (restaurants.`rating` LIKE '%#{rating}%')"

    puts rating.inspect.green.bold
    puts params.inspect.yellow.bold

    @locations = Location.find_by_sql("SELECT DISTINCT
                      locations.*
                    FROM
                      locations,
                      restaurants,
                     cities,
                      states,
                      cuisines,
                      menus
                    WHERE
                      locations.restaurant_id = restaurants.id
                      AND locations.city_id = cities.id
                      AND cities.state_id = states.id
                      AND menus.restaurant_id = locations.restaurant_id
                      #{cuisine_ref}
                    AND (
                      restaurants.name LIKE '%#{keyword}%'
                      OR states.state LIKE '%#{keyword}%'
                      OR states.state_code LIKE '%#{keyword}%'
                      #{city2}
                    ) #{cuisine_val}
                                      #{rating_val}
                                      #{city}"

    )

    #cu1 = cuisine == "" ? "" :"join cuisines cu on cu.restaurant_id = r.id"
    #cu2 = cuisine == "" ? "" :"AND cu.`name` LIKE '%#{cuisine}%'"
    #
    #c1 = (params[:city] == "" && !params[:city]) ? "" :"join cities c on l.city_id = c.id"
    #c2 = (params[:city] == "" && !params[:city]) ? "" :"AND cu.`name` LIKE '%#{cuisine}%'"

#    @locations = Location.find_by_sql("SELECT  l.*
#FROM locations l join
#     restaurants r
#     on l.restaurant_id = r.id join
#     states s
#     on c.state_id = s.id
##{cu1}
##{c1}
#WHERE (r.name LIKE '%#{zip}%' OR
#       c.city LIKE '%#{zip}%' OR
#       l.zip LIKE '%#{zip}%' OR
#       s.state LIKE '%#{zip}%' OR
#       s.state_code LIKE '%#{zip}%'
#      ) AND
#      r.delivery_type in (0, 1) #{cu2}
#AND ((l.latitude > 0) OR (l.latitude < 0))
#AND ((l.longitude > 0) OR (l.longitude < 0));")


    puts( @locations.inspect.red)


    if @locations.nil?

      render json: {locations: []}.to_json
    end

  end

  def get_from_current_location
    puts params.inspect.green

    latitude = params[:latitude]
    longitude = params[:longitude]

    @locations = Location.find_by_sql("SELECT DISTINCT
                      locations.*, geo_distance (
                                    #{latitude},
                                    #{longitude},
                                    ifnull(latitude + 0, 0.0),
                                    ifnull(longitude + 0, 0.0)
                                  ) AS `distance`
                    FROM
                      locations,
                      restaurants,
                     cities

                    WHERE
                      locations.restaurant_id = restaurants.id
                      AND locations.city_id = cities.id

                    HAVING
	                    distance <= 500")


    puts( @locations.inspect.red)

    if @locations.nil?

      render json: {locations: []}.to_json

    end
  end

  def set_menu
    puts '----------set-----------------manu---------------------'
    restaurant = Restaurant.find_by_id(params[:rest_id])
    @menu = restaurant.menus
    #@products = @menu.first.products
  end



  def set_menu_items
    puts '----------set-----------------manu---------------------'
    menu = Menu.find_by_id(params[:menu_id])
    @items = menu.products


    puts "-------menu---#{@items.inspect}"
  end
end
