class Api::OrdersController < ApplicationController
  before_filter :api_authentikate_user
  def create_cart
    puts "============================createating  items -----------------------"
    puts params.inspect
    puts params[:cart].inspect
    cart_data =  params[:cart]
    @current_user
    @session

    if @session.cart
      @cart = @session.cart
      @cart.line_items.destroy_all

     else
      @cart = current_cart
      @cart.line_items.destroy_all
    end


    @session.cart = @cart
    session[:cart_id]  = @session.cart.id

    @session.save
   puts "============================createating  items -----------------------".red.bold
    cart_data.delete('total') if cart_data['total']
    #puts cart_data.id.red.bold
    cart_data.each do |item|
      puts item.inspect
      puts item[1]["item"].to_i.to_s.blue

       (item[1]["item"].to_i).times do
         @line_item = LineItem.new(params[:line_item])
         @line_item = @cart.add_product(item[1]["product_id"])
         @line_item.save
       end
    end
    puts @session.cart.line_items.inspect
    render json: "success"
  end
end
