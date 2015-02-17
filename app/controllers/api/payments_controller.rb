class Api::PaymentsController < ApplicationController
  before_filter :api_authentikate_user, except: [:payment]
  respond_to :json

  def payment
    puts params.inspect.red

    credit_card = create_cart(params)

    if credit_card.valid?



      gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(
          :login => AUTHORIZE_NET_CONFIG['api_login_id'],
          :password => AUTHORIZE_NET_CONFIG['api_transaction_key'],
          :gateway => :sandbox
      )

      sum = params[:order][:sum]



      if !sum
        sum = 0
      end

      puts sum.to_s.green

      @response = gateway.purchase(sum.to_i, credit_card)

      puts @response.inspect.green.bold

      #if @response.success?
      #
      #  @order = current_user.orders.create(params[:orders])
      #
      #
      #  current_cart.line_items.each do |i|
      #
      #    @order.order_items.create(product_id: i.product.id, count: i.quantity)  if i.restaurant.id == restaurant
      #  end
      #
      #
      #  if @order
      #
      #  end
      #
      #end

      render json: @response

    else

      puts credit_card.inspect.red.bold

      render :json=> credit_card.errors, :status=>422

    end




  end

  def create_cart(params)

    cart = {
        first_name: params[:card]['name'],
        last_name: params[:card]['last_name'],
        number: params[:card]['card_number'],
        verification_value: params[:card]['code'],
        month: params[:card]['month'],
        year: params[:card]['year']
    }
    credit_card = ActiveMerchant::Billing::CreditCard.new(
        cart
    )
    credit_card

  end

end