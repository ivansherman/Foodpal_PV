class UsersController < ApplicationController

  before_filter :unauthorized, except: [:generate_new_password_email]
  before_filter :authenticate_user!, except: [:generate_new_password_email, :edit_user_password]


  add_breadcrumb "Home", :root_path

  def index
  puts current_user.inspect.yellow
  puts params.inspect.green
    if params[:user_id]
      user =  User.find_by_id(params[:user_id])
      sign_in user
    end

    @user = User.find(current_user.id)
    @user.address = Address.new unless @user.address

    @country = Country.new

    @state = State.new

    add_breadcrumb current_user.name, :user_path
  end


  def update
    puts params.inspect.yellow.bold


    @user = User.find_by_id(current_user.id)

    if @user.update_attributes(params["user"])

      @user.address ? @user.address : @user.address = Address.create

      @user.address.update_attributes(params[:address])

    end
    puts @user.errors.messages.inspect.red.bold
    redirect_to user_path
  end

  def update_user
    puts params.inspect.yellow.bold


    @user = User.find_by_id(params["user"]["id"])

    if @user.update_attributes(params["user"])

      @user.address ? @user.address : @user.address = Address.create

      @user.address.update_attributes(params[:address])

    end
    puts @user.errors.messages.inspect.red.bold
    redirect_to users_list_path
  end

  def select_country
    country = Country.find_by_id(params[:id])
    @states = country.states

    render json: @states
  end

  def select_state
    state = State.find_by_id(params[:id])
    @cities = state.cities.order(:city)

    render json: @cities
  end

  def ready_city
    state = current_user.address.city.state
    @cities = state.cities.order(:city)

    render json: @cities
  end

  def get_user_state
    puts "State".green
    puts current_user.address.inspect.light_blue

    state = current_user.address.city.state if current_user.address.city


    puts state.inspect.magenta.bold

    render json: state
  end

  def get_user_city
    city = current_user.address.city

    render json: city
  end

  def update_password

    puts params.inspect.green

    @user = current_user

    if @user.update_attributes(params[:user])

      puts current_user.inspect.blue
      redirect_to user_path({user_id: @user.id}), :notice => "Succes update"
    else
      sign_in @user
      redirect_to user_path({user_id: @user.id}), :notice => @user.errors.messages
    end

  end

  def user_params
    # NOTE: Using `strong_parameters` gem
    params.required(:user).permit(:password, :password_confirmation)
  end

  def list
    #@users = User.paginate(:page => params[:page], :per_page => 20)
    @tasks_grid = initialize_grid(User, :include => [:roles])

    add_breadcrumb current_user.name, :user_path
    add_breadcrumb "Users Management", :users_list_path
  end

  def user_edit
    @user = User.find_by_id(params[:id])
    @user.address = Address.new unless @user.address
    @roles = Role.all

    add_breadcrumb current_user.name, :user_path
    add_breadcrumb "Users Management", :users_list_path
    add_breadcrumb "Edit \"" + @user.name + "\"" , :users_list_path
    render "users/edit"
  end

  def generate_new_password_email
    puts params.inspect.red
    user = User.where(email: params[:user][:email]).first

    if user
      user.send_reset_password_instructions
      flash[:notice] = "Reset password instructions have been sent to #{user.email}."
      redirect_to root_path
    else
      flash[:notice] = "Foodpal does not have this email listed in the database. Please create a new account or contact us at info@foodpal.com for more information."
      redirect_to :back
    end
  end

end
