class LineItemsController < ApplicationController
  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.find_all_restaurant(current_restaurant)

    puts @line_items.inspect.magenta

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @line_items }
    end
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
    puts params.inspect.green

    @line_item = LineItem.find(params[:id])

    puts @line_items.inspect.magenta

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @line_item }
    end
  end

  # GET /line_items/new
  # GET /line_items/new.json
  def new
    @line_item = LineItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @line_item }
    end
  end

  # GET /line_items/1/edit
  def edit
    @line_item = LineItem.find(params[:id])
  end

  # POST /line_items
  # POST /line_items.json
  def create

    puts params.inspect.green
    puts params[:remove].inspect.yellow

    @cart = current_cart

    product = Product.find_by_id(params[:line_item][:product_id])

    location = Location.find_by_id(session[:current_location_id])

    if !params[:remove]
      puts "Add".yellow
      restaurant = product.menu.restaurant
      @line_item = LineItem.where(cart_id: @cart.id, :product_id => product.id).first_or_create
      @line_item.update_attributes(params[:line_item])


        if @line_item.save

          render partial: 'restaurants/cart', locals:{location: location}
        else
          render partial: 'restaurants/cart'
        end

    else
      puts "Remove".yellow

      puts
      @line_item = LineItem.where(cart_id: @cart.id, :product_id => product.id).first

      puts @line_item.inspect.magenta

      @line_item.destroy

      render partial: 'restaurants/cart', locals:{location: location}
    end
  end

  # PUT /line_items/1
  # PUT /line_items/1.json
  def update
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      if @line_item.update_attributes(params[:line_item])
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy

    respond_to do |format|
      format.html { redirect_to line_items_url }
      format.json { head :no_content }
    end
  end

  def remove_item
    puts '---remove---------------------item--------------'.red
    puts params[:cart_id]
    @cart =  (params[:cart_id])? Cart.find_by_id(params[:cart_id]) : current_cart
    location = Location.find_by_id(session[:current_location_id])
    puts @cart.inspect
    line_item = LineItem.where(product_id: params[:product_id], cart_id: @cart.id).first
    @line_item = @cart.remove_product(line_item)

      render partial: 'restaurants/cart', locals:{location: location}

  end


end
