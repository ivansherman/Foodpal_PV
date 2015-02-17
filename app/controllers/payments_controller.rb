class PaymentsController < ApplicationController
  before_filter :authenticate_user!
  protect_from_forgery :except => :relay_response

  def payment

    @location = Location.find_by_id(params['location_id'])
    @cart = current_cart


    sum = 0
    @cart.line_items.map{|line_item| sum += (line_item.product_price.to_f * line_item.quantity.to_i).to_f}

    params['orders']['totalprice'] = sum
    params['orders']['status_id'] = 1
    params['orders']['location_id'] = session[:current_location_id]

    if params[:orders][:payment_method] == "false"

      #ActiveMerchant::Billing::Base.mode = :test


      credit_card = create_cart(params)

      if credit_card.valid?

        # ActiveMerchant::Billing::Base.mode = :test

        # Create a gateway object to the TrustCommerce service
        gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(
                   :login => AUTHORIZE_NET_CONFIG['api_login_id'],
                   :password => AUTHORIZE_NET_CONFIG['api_transaction_key'],

                  )


        sum = (sum) * 100;

        puts sum.to_s.magenta.bold
        @response = gateway.purchase(sum, credit_card)

        if @response.success?

          puts @response.inspect.green

          params['orders']['delivery_time'] = params['orders']['delivery_time(5i)']
          params['orders'].delete('delivery_time(5i)')
          params['orders']['transaction_id'] = @response.params["transaction_id"]
          current_user.orders.create(params[:orders])
          restaurant = Location.find_by_id(session[:current_location_id]).restaurant.id

          params['orders']['success_key'] = SecureRandom.hex
          params['orders']['cancel_key'] = SecureRandom.hex

          @order = current_user.orders.create(params[:orders])

          if @order

            current_cart.line_items.each do |i|

                 @order.order_items.create(product_id: i.product.id, count: i.quantity)  if i.restaurant.id == restaurant
            end

            
            ContactMailer.order_email(@order, @location).deliver

            flash[:success] = "Your order sent!"
            redirect_to @order

          else
            @order.errors
            redirect_to :back
          end

        else

          flash[:error] = @response.message
          redirect_to :back

        end

      else

        @response = credit_card.errors

        puts @response.inspect.red.bold

        flash[:error] = []
        credit_card.errors.each do |key, value|
          flash[:error] << key.to_s + ": " + value[0].to_s

        end
        redirect_to :back


      end

    else
      params['orders']['delivery_time'] = params['orders']['delivery_time(5i)']
      params['orders'].delete('delivery_time(5i)')

      params['orders']['success_key'] = SecureRandom.hex
      params['orders']['cancel_key'] = SecureRandom.hex

      restaurant_id = Location.find_by_id(session[:current_location_id]).restaurant_id

      @order = current_user.orders.create(params[:orders])

      if @order

        current_cart.line_items.map do |i|
         puts restaurant_id.to_s.green
         puts i.restaurant.id.to_s.red
         @order.order_items.create(product_id: i.product.id, count: i.quantity)  if i.restaurant.id == restaurant_id

        end
    
        ContactMailer.order_email(@order, @location).deliver

        @cart.line_items.destroy_all
        flash[:success] = "Your order sent!"
        redirect_to @order
      else

        @order.errors
        redirect_to :back

      end

    end


  end


  def create_cart(params)

    cart = {
        first_name: params['card']['name'],
        last_name: params['card']['last_name'],
        number: params['card']['card_number'],
        verification_value: params['card']['code'],
        month: params['card']['month(2i)'],
        year: params['card']['year(1i)']
    }
    credit_card = ActiveMerchant::Billing::CreditCard.new(
        cart
    )
    credit_card

  end


end
