class RestaurantsController < ApplicationController

  before_filter :unauthorized, except: [:index, :search, :show, :listing, :get_cuisine, :list, :craving_blogs, :craving_restaurants]
  before_filter :store_location
  skip_before_filter :authenticate_user!, exept: [:index, :search]
  add_breadcrumb "Home", :root_path

  def index
    puts "INDEX".green.bold
    @locations = []
  end

  def search
    puts "SEARCH".green.bold
    puts params.inspect.yellow.bold
    zip = params[:zip].gsub(/['"\\\x0]/,'\\\\\0')
    delivery = params[:delivery]

    cuisine = params[:cuisine]
    puts cuisine.red.bold

    cuisine_val = cuisine == "" ? "" : "AND (cuisines.`name` LIKE '%#{cuisine}%')"
    cuisine_ref = cuisine == "" ? "" : "AND cuisines.restaurant_id = restaurants.id"

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
    #                  #{cuisine_ref}
    #                AND (
    #                  restaurants.name LIKE '%#{zip}%'
    #                  OR cities.city LIKE '%#{zip}%'
    #                  OR cities.zip LIKE  '%#{zip}%'
    #                  OR states.state LIKE '%#{zip}%'
    #                  OR states.state_code LIKE '%#{zip}%'
    #                ) AND (restaurants.delivery_type = '#{delivery}' OR restaurants.delivery_type = 0)
    #                  #{cuisine_val}
    #                                  "
    #)

    c1 = cuisine == "" ? "" :"join cuisines cu on cu.restaurant_id = r.id"
    c2 = cuisine == "" ? "" :"AND cu.`name` LIKE '%#{cuisine}%'"

    puts ("Filter " + params["filter"].to_s).green.bold
    puts params["filter"].class.inspect.bold.red

    if params["filter"] == "1"
      s_r = "join restaurants r on l.restaurant_id = r.id"
      s_v = "r.name LIKE '%#{zip}%'"
    elsif params["filter"] == "2"
      s_r = "join restaurants r on l.restaurant_id = r.id join cities c on l.city_id = c.id"
      s_v = "c.city LIKE '%#{zip}%'"
    elsif params["filter"] == "3"
      s_r = "join restaurants r on l.restaurant_id = r.id "
      s_v = "l.zip LIKE '%#{zip}%'"
    elsif params["filter"] == "3"
      s_r = "join restaurants r on l.restaurant_id = r.id join states s on c.state_id = s.id"
      s_v = "s.state LIKE '%#{zip}%' OR s.state_code LIKE '%#{zip}%'"

    else
      s_r = "join restaurants r on l.restaurant_id = r.id join cities c on l.city_id = c.id join states s on c.state_id = s.id"
      s_v = "r.name LIKE '%#{zip}%' OR c.city LIKE '%#{zip}%' OR l.zip LIKE '%#{zip}%' OR s.state LIKE '%#{zip}%' OR s.state_code LIKE '%#{zip}%'"

    end

    @locations = Location.find_by_sql("SELECT  l.*
FROM locations l #{s_r}
#{c1}
WHERE (#{s_v}
      ) AND
      r.delivery_type in (0, 1) #{c2}
AND ((l.latitude > 0) OR (l.latitude < 0))
AND ((l.longitude > 0) OR (l.longitude < 0));")


    @hash = Gmaps4rails.build_markers(@locations) do |loc, marker|
      marker.lat loc.latitude
      marker.lng loc.longitude
      marker.picture ({"url" => "assets/icoFoodpal.png",
                       "width" => 36,
                       "height" => 36})
      marker.infowindow render_to_string(:partial => "restaurants/info_window", :locals => {loc: loc, marker: marker})

      loc.restaurant.id.to_s
    end

    @keyword = zip

    #@locations = @locations.paginate(:page => params[:page], :per_page => 5)
    #@locations = WillPaginate::Collection.new(params[:page], 5, self.size)

    render partial: 'restaurants/restaurant_list'
    #respond_to do |respond|
    #  respond.js
    #end
  end


  def show

    puts "SHOW".green.bold
    puts current_cart.inspect.magenta
    @cart = current_cart
    @loc = Location.find_by_id(params[:id])
    #@restaurant = Restaurant.find_by_id(params[:id])     if params[:id]
    #session[:current_restaurant_id] = @loc.restaurant.id
    session[:current_location_id] = @loc.id

    @comment = Comment.new

    @last_comment = @loc.restaurant.comments.last

    @blogs = Blog.new

    add_breadcrumb @loc.restaurant.name, restaurant_path

    params[:client] = @loc.restaurant.name.gsub!(" ", "_")
    @client_name = params[:client]
    if @client_name.nil?
      @client_name = "unnamed"
    end

    @card_page = true
    capability = Twilio::Util::Capability.new TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN
    # Create an application sid at twilio.com/user/account/apps and use it here
    capability.allow_client_outgoing TWILIO_APP_SID
    capability.allow_client_incoming @client_name
    @token = capability.generate

  end


  def compact_colection(model, field, parametr)
    collection = model.where("#{field} like ?", "%#{parametr}%").map { |city| city.locations }
    collection = model.where("#{field} like ?", "%#{parametr}%").map { |city| city.locations }
    collection.flatten!
    collection.compact!
    collection.uniq!
    puts '-------------------collection----------------------------------'
    puts "---#{parametr}----"

    puts collection.count
    collection
  end


  def listing
    @restaurants = Restaurant.where(:list => 1).paginate(:page => params[:page], :per_page => 20)

    add_breadcrumb "Free Restaurant Listing Application", restaurants_listing_path
  end

  def get_cuisine
    @cuisines = Cuisine.where("cusine like ?", "%#{params[:cuisine]}%")

    puts @cuisines.inspect.green

    render json: @cuisines
  end

  def craving_restaurants
    #@restaurants = Location.where("((restaurants.name like ? or restaurants.description like ? ) and locations.restaurant_id = restaurants.id )", "%" + params[:keyword] + "%", "%" + params[:keyword] + "%")

    @locations = Location.find_by_sql("SELECT DISTINCT
                                          `locations`.*
                                        FROM
                                          `restaurants`,
                                          locations,
                                          menus,
                                          products
                                        WHERE
                                          (
                                            restaurants.`name` LIKE '%#{params[:keyword]}%'
                                            OR restaurants.description LIKE '%#{params[:keyword]}%'
                                            OR menus.`name` LIKE '%#{params[:keyword]}%'
                                            OR menus.`description` LIKE '%#{params[:keyword]}%'
                                            OR products.`name` LIKE '%#{params[:keyword]}%'
                                            OR products.`description` LIKE '%#{params[:keyword]}%'
                                          )
                                        AND locations.restaurant_id = restaurants.id
                                        AND menus.restaurant_id = restaurants.id
                                        AND products.menu_id = menus.id"
    )


    render partial: "restaurants/recomended_restaurant"
  end


  def craving_blogs
    @blogs = Blog.where('title like ? or text like ? ', "%" + params[:keyword] + "%", "%" + params[:keyword] + "%").all

    render partial: "restaurants/recomended_blogs"
  end

  def edit
    puts "EDIT".green.bold

    @menu = Menu.new

    @product = Product.new

    @restaurant = Restaurant.find_by_id(params[:id])

    puts @restaurant.list.to_s.red.bold

    add_breadcrumb current_user.name, user_path
    add_breadcrumb "Restaurants Management", restaurants_list_path
    add_breadcrumb "Edit \"" + @restaurant.name + "\"", edit_restaurant_path(@restaurant)
  end


  def update
    puts params.inspect.yellow.bold
    @restaurant = Restaurant.find_by_id(params[:id])

    if @restaurant.update_attributes(params[:restaurant])
      flash[:success] = "Restaurant updated"
      redirect_to :back
    else
      flash[:error] = @restaurant.errors.messages
      redirect_to :back
    end
  end

  def new

    @restaurant = Restaurant.new

    add_breadcrumb "Restaurants Management", restaurants_list_path
    add_breadcrumb "New Restaurant", restaurants_new_path

  end

  def create
    puts params.inspect.red

    if params[:restaurant][:delivery_type] == "" || !params[:restaurant][:delivery_type]
      params[:restaurant][:delivery_type] = 1
    end

    if params[:restaurant][:payment_type] == "" || !params[:restaurant][:payment_type]
      params[:restaurant][:payment_type] = 1
    end

    @restaurant = current_user.restaurants.new(params[:restaurant])

    if @restaurant.save

      flash[:success] = @restaurant.name + " added"
      redirect_to edit_restaurant_path(@restaurant)
    else
      flash[:error] = @restaurant.errors.messages
      render "new"
    end


  end

  def destroy
    @restaurant = Restaurant.find_by_id(params[:id])

    @restaurant.destroy

    flash[:success] = "Restaurant deleted"
    redirect_to restaurants_list_path

  end

  def list
    if current_user.role? :admin
      #@restaurants = Restaurant.paginate(:page => params[:page], :per_page => 20)
      @restaurants = initialize_grid(Restaurant)
    elsif current_user.role? :customer
      #@restaurants = current_user.restaurants.paginate(:page => params[:page], :per_page => 20)
      @restaurants = initialize_grid(Restaurant, :conditions => ['user_id = ?', current_user])
    else
      @restaurants = Restaurant.new
    end

    add_breadcrumb current_user.name, user_path
    add_breadcrumb "Restaurants Management", restaurants_list_path
  end

  def vote
    puts params.inspect.green

    @ratings = Rating.where(:restaurant_id => params["idBox"])

    if current_user.ratings.where(:restaurant_id => params["idBox"]).blank?
      @rating = current_user.ratings.create(:restaurant_id => params["idBox"], :value => params["rate"])
      @restaurant = Restaurant.find_by_id(params["idBox"])
      #summary_rating = 0
      #@ratings.map{|rating| summary_rating += (rating.value.to_f).to_f}
      #puts "Summary: " + summary_rating.to_s.green.bold
      #@restaurant.rating = summary_rating / @ratings.count
      rating = @restaurant.ratings.average("value")
      puts "New Rating: " + rating.to_s.green
      puts @restaurant.update_attributes(rating: rating)


      render json: {:status => "ok"}
    else
      render json: {:status => "error", :message => "You have already voted"}
    end


  end

  def import_excel
    puts params.inspect.red
    fname =params['excel'].original_filename
    import_file = params[:excel]
    rest = Restaurant.find_by_id(params[:rest_id])
    if (fname =~ /.xlsx/).nil?
      format = '.xls'
    else
      format = '.xlsx'
    end

    puts "--------format---------------#{format}"
    Restaurant.import_from_excel(import_file, rest, format)
    begin

    rescue

    end
    redirect_to :back
  end

  def locations_import_excel
    puts params.inspect.red
    fname =params['excel'].original_filename
    import_file = params[:excel]

    if (fname =~ /.xlsx/).nil?
      format = '.xls'
    else
      format = '.xlsx'
    end

    puts "--------format---------------#{format}"
    Restaurant.import_r_from_excel(import_file, format)
    begin

    rescue

    end
    redirect_to :back
  end


end
