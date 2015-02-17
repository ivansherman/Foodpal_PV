class Admins::RegistrationsController < Devise::RegistrationsController

  def create

    @user = User.new(params[:user])

    if @user.save
      @user.roles = [Role.find_by_name("user")]
      sign_in @user

      redirect_to :back
    else
      puts @user.errors.inspect.red
      flash[:error] = []
      @user.errors.messages.each do |key, value|
        flash[:error] << key.to_s + ": " + value[0].to_s
      end
      redirect_to :back
    end

  end

  #def update
  #  puts "BUEEEEK".red
  #  puts resource.errors.inspect.blue
  #
  #  puts flash.inspect.green
  #  redirect_to :back
  #end


  def after_update_path_for(resource)
    puts "BUEEEEK".red
    root_path
  end

end