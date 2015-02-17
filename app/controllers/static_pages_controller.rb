class StaticPagesController < ApplicationController
  add_breadcrumb "Home", :root_path

  def about_us
    add_breadcrumb "About Us", about_us_path
  end

  def careers
    add_breadcrumb "Careers", careers_path
  end

  def founder
    add_breadcrumb "About Us", about_us_path
    add_breadcrumb "Founder of Foodpal", founder_of_foodpal_path
  end

  def private_policy
    add_breadcrumb "About Us", about_us_path
    add_breadcrumb "Privacy Policy", privacy_policy_path
  end

  def how_works
    add_breadcrumb "How Foodpal works", how_foodpal_works_path
  end

  def media_kit
    add_breadcrumb "Media Kit", media_kit_path
  end

  def contact
    add_breadcrumb "Contact Us", contact_path
  end

  def dispatch_email





    user_info = params[:user_info]
    subject = params[:subject]

    puts user_info.inspect.red
    if ContactMailer.send_email(user_info, subject).deliver
      flash[:notice] = "Sent!"
    else
      flash[:notice] = "Could't send you message."
    end
    redirect_to contact_url
  end




end
