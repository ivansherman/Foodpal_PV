class ApplicationController < ActionController::Base
  config.time_zone = 'Eastern Time (US & Canada)'
  protect_from_forgery
  before_filter :before_set_access_control_headers
  after_filter :set_access_control_headers
  after_filter :store_location
  after_filter :flash_to_headers



  def flash_to_headers
    if request.xhr?
      #avoiding XSS injections via flash
      flash_json = Hash[flash.map{|k,v| [k,ERB::Util.h(v)] }].to_json
      response.headers['X-Flash-Messages'] = flash_json
      flash.discard
    end
  end

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    if (request.fullpath != "/users/sign_in" &&
        request.fullpath != "/users/sign_up" &&
        request.fullpath != "/users/password" &&
        request.xhr?.nil?) # don't store ajax calls
          session[:previous_url] = request.fullpath
    end
    puts  session[:previous_url].inspect.to_s.green.bold
    puts  request.ip
    puts  request.url
    session[:api] = request.ip

  end

  def after_sign_in_path_for(resource)
    puts '-------------------after------in------------'.red
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  def after_sign_out_path_for(resource)
    puts '-------------------after----aut--------------'.red
    root_path
  end

  def before_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Max-Age'] = "1728000"
    headers['Access-Control-Request-Method'] = '*'
  end

  def api_authentikate_user(token=nil)

    params[:authentication_token] = token  if token
    puts "sign  in ".red.bold
    @session = Session.where(:auth_token => params[:authentication_token]).first

    puts params[:authentication_token].inspect.green.bold
    puts @session.inspect.green.bold
    unless @session
      puts params
      bad_request ['session invalid or expired'], 401
    else
      @session[:updated_at] = Time.now
      @current_user = @session.user
      unless @current_user
        bad_request ['session invalid or expired'], 401

        session = Session.find_by_user_id(@session.user_id)
        session.destroy
      end
    end
  end

  def unauthorized
    puts "unauthorized".red.bold
    if !current_user
      render "errors/unauthorized"
    end
  end


  private

  def current_cart

    Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    puts cart = Cart.create
    session[:cart_id] = cart.id
    puts cart.inspect
    cart

  end



  def bad_request(errors, status = 200)
    set_access_control_headers
    status = 422
    warden.custom_failure!
    render(:json => {:errors => errors}, :status => status) and return
  end




end
