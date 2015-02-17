class Api::UsersController < ApplicationController

    before_filter :authenticate_user!, only: [:index]
    before_filter :api_authentikate_user, except: [:create, :sign_in, :sign_up, :index, :destroy]
    respond_to :json

    def create
      puts params
      Rails.logger.info "Year: #{params}"

      user = User.new(params[:user])

      puts '-----------------------validation-----------------------------------' if user.valid?
      puts user.valid?                                                            if user.valid?


      if user.valid?
        puts "------save user----------------"
        #user.skip_validation_inst = true

        user.validation_confirm = 'api'
        #User.skip_callback
        puts user.save

        session = create_session(user)
        puts Session.create(session)
	

        render :json=> {:auth_token=>session[:auth_token], :email=>user.email, user: user.as_json} , :status=>201

      else

        render :json=> user.errors, :status=>422
      end
    end
    
    def sign_up
      puts params
      Rails.logger.info "Year: #{params}"

      user = User.new(params[:user])

      puts '-----------------------validation-----------------------------------' if user.valid?
      puts user.valid?                                                            if user.valid?


      if user.valid?
        puts "------save user----------------"
        #user.skip_validation_inst = true

        user.validation_confirm = 'api'
        #User.skip_callback
        puts user.save

        session = create_session(user)
        puts Session.create(session)
	

        render :json=> {:auth_token=>session[:auth_token], :avatar=>user.avatar.url(:thumb), :email=>user.email, user: user.as_json} , :status=>201

      else

        render :json=> {:errors=>user.errors}, :status=>422
      end
    end

    def sign_in
      puts "sign in ---------------------------------------------------------".red.bold

      user = User.find_for_database_authentication(:login=> params[:user][:login])

      puts "-user---#{user}-----------------------".green
      if user && user.valid_password?(params[:user][:password])


        session = create_session(user)
        Session.create(session)

        puts user.inspect.red
        render :json=> {:auth_token=>session[:auth_token], :avatar=>user.avatar.url(:thumb) ,:email=>user.email, user: user.as_json} , :status=>201

      else
        bad_request ['Invalid login or password'], 401
      end

    end



    def index

    end


    def destroy

      session = Session.where(:auth_token => params[:authentication_token]).first
      if session
        #render json: session
        destroy_session(session)    if session
        render :json => { :success => true,  :info => "Logged out", :status => 200 }
      else
        bad_request ['invalid login or password'], 433
      end
    end



    def show
      render json: {user: @current_user.as_json}

    end


    def update
      puts '------update-----------------------'
      puts params
      user = User.new
      user.assign_attributes(params[:user])

      puts user.valid?

      if  @current_user.update_attributes(params[:user])
        render json: {user: @current_user.as_json}
      else
        render :json=> @current_user.errors, :status=>422
      end

    end


    def orders
      puts params.inspect.red
      @orders = @current_user.orders
      orders = [];


      puts params.inspect.red
      @orders = @current_user.orders
      orders = []
      @orders.each do |order|
        puts "----status---------------------#{order.status.inspect}"
        number = order.transaction_id ? order.transaction_id : 'cash'
        status =  (order.status)?  order.status.title : 'Not paid'
        orders << {number: number, state: status }
      end

      render json: orders.to_json

    end


    private


    def create_session(user)

      range = [*'0'..'9', *'a'..'z', *'A'..'Z']
      session = {user_id: user.id, auth_token: Array.new(30){range.sample}.join, updated_at: Time.now}
      session

    end

    def destroy_session session

      session.destroy
    end


end
