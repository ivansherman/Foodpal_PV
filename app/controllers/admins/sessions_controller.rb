class Admins::SessionsController < Devise::SessionsController

  def create
    puts '---------------------------------------params-------------------------'
    puts '---------------------------------------params-------------------------'
    puts '---------------------------------------params-------------------------'
    puts params.inspect

    @user = User.find_for_database_authentication(:login=> params[:user][:login])

    @user = User.find_for_database_authentication(:email=> params[:user][:login])  unless @user


    if @user && @user.valid_password?(params[:user][:password])
      sign_in @user

      redirect_to :back

    else
      flash[:error] = "Wrong login or password"
      redirect_to :back
    end

  end



end