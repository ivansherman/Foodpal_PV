class OrdersController < ApplicationController
  #before_filter :authenticate_user!
  before_filter :unauthorized, except: [:index]
  add_breadcrumb "Home", :root_path

  def index

    puts '----------index----------------------------'
    if params['session']
      puts  params['session'].inspect.blue
      params[:authentication_token] =  params['session']
      api_authentikate_user( params['session'])
      @location = Location.find_by_id(params['loc_id'])
      sign_in @current_user
      session[:current_location_id]= @location.id
      @cart = @session.cart
      session[:cart_id] = @cart.id
      puts @cart.inspect.green
      @api = 'api'
    else
      @cart = current_cart
      @location = Location.find_by_id(session[:current_location_id])
    end

    current_user


    add_breadcrumb @location.restaurant.name, restaurant_path(@location)  if  @location
    add_breadcrumb "Orders", orders_index_path

  end

  def list

      @orders = current_user.orders.order("created_at DESC").paginate(:page => params[:page], :per_page => 20)



    add_breadcrumb current_user.name, user_path
    add_breadcrumb "Orders List", orders_list_path
  end

  def show

    puts params.inspect.magenta.bold

    @order = Order.find_by_id(params[:id])

    key = params['security_key']

    if (key && key != "")
      if key == @order.success_key
        change_status(@order, 2)

      elsif key == @order.cancel_key
        change_status(@order, 3)

      end
    end

    @location = @order.location

    add_breadcrumb @location.restaurant.name, restaurant_path(@location)
    add_breadcrumb "Orders", orders_list_path
    add_breadcrumb @order.created_at.strftime("\"%m/%d/%Y \n\rat %I:%M %p\""), order_path(@order)
  end

  def status
    puts params.inspect.green

    @order = Order.find_by_id(params[:order_id])

    if @order.update_attributes(:status_id => params[:status])
      render json: {status: 200, color: @order.status.color, message: @order.status.title}
    end



  end

  def restaurants_orders

    if params[:id]
      @location = Location.find_by_id(params[:id])
      @orders = @location.orders.order("created_at DESC").paginate(:page => params[:page], :per_page => 20)
    end
    #@orders = current_user.orders.paginate(:page => params[:page], :per_page => 20)

    add_breadcrumb current_user.name, user_path
    add_breadcrumb "Restaurants List", restaurants_list_path
    add_breadcrumb "\"" + @location.restaurant.name + "\" Orders List", "/orders/restaurants_orders/#{@location.id.to_s}"
  end

  def change_status(order, status)
    if order.update_attributes(:status_id => status)
      puts "changed".green.bold
      ContactMailer.change_status(order).deliver
      return true
    else
      return false
    end
  end

end
