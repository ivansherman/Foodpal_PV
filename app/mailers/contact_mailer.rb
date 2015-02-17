class ContactMailer < ActionMailer::Base
  #attr_accessor :name, :email, :message

  default to: "name@myapp.com",
          from: "contact@myapp.com"

  headers = {'Return-Path' => 'contact@myapp.com'}

  def send_email(user_info, subject)
    puts "In contact mailer".green
    @user_info = user_info
    puts user_info.inspect.red

    #mail(
    #    #to: "zehelloworld@gmail.com",
    #    #subject: "MyApp's Contact Form",
    #    #from: "MyApp <contact@myapp.com>",
    #    #return_path: "contact@myapp.com",
    #    #date: Time.now,
    #    #content_type: "text/html"
    #
    #)

    mail(to: "viktor.danch@gmail.com",
         from: @user_info['email'],
         subject: subject,
         content_type: "text/html"
         )
  end


  def change_password(user)
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logo.png")
    @user = user
    puts 'send_email'
    mail(to: user.email,
         from: "cdicioccio@foodpal.com",
         subject: 'Foodpal change password',

    )

  end

  def order_email(order, location)

    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logo.png")
    attachments.inline['cutlery.png'] = File.read("#{Rails.root}/app/assets/images/cutlery.png")
    if !location.restaurant.image.url(:medium).include? "imagenotavailable"
      attachments.inline['restaurant_logo.png'] = File.read("#{Rails.root}/public#{location.restaurant.image.url(:medium).split("?")[0]}")
    end


    @order = order
    @location = location
    puts "order".yellow

    mail(to: order.location.restaurant.email,
        from: "cdcioccio@foodpal.com",
        subject: "You have new order",
        )


    if order.location.phone && order.location.phone !=""
      @client = Twilio::REST::Client.new TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN

      call = @client.account.calls.create(:url => "http://foodpal.com/xmls/voice.xml",
                                          :to => order.location.phone,
                                          :from => TWILIO_USER_NUMBER
      )
      puts call.to
    end

  end

  def change_status(order)
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logo.png")

    @order = order

    mail(to: order.user.email,
         from: "cdcioccio@foodpal.com",
         subject: "Status changed",
    )

  end

end
