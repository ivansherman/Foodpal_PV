# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#Role.destroy_all
#[:admin, :user, :customer ].each do |role|
#  Role.create(:name => role)
#end
#
#admin = User.new(:name => "Foodpal Admin", :login => "foodpal", :password => "qwerty11", :password_confirmation => "qwerty11", :email => "admin@foodpal.com")
#admin.validation_confirm = 'api'
#admin.roles = [Role.find_by_name("admin")]
#admin.save
#
#user = User.new(:name => "Foodpal User", :login => "user", :password => "qwerty11", :password_confirmation => "qwerty11", :email => "user@foodpal.com")
#user.validation_confirm = 'api'
#user.roles = [Role.find_by_name("user")]
#user.save
#
#customer = User.new(:name => "Foodpal Customer", :login => "customer", :password => "qwerty11", :password_confirmation => "qwerty11", :email => "customer@foodpal.com")
#customer.validation_confirm = 'api'
#customer.roles = [Role.find_by_name("customer")]
#customer.save

#puts "Admin created".cyan.bold
#puts admin.errors.messages.to_s.cyan.bold


#locations = Location.all
#
#locations.each do |loc|
#  loc.state_id = loc.city.state.id if  loc.city && loc.city.state
# puts loc.save
#end

#products = Product.all
#i = 0
#no_blank = 0
#products.each do |p|
#  i += 1;
#
#  puts i.to_s.red
#  image = p.picture
#  url =  Rails.root.join('public', 'images', image)
#  print url.to_s.green
#  no_blank +=1 unless '/home/schwarz/project/foodpal_ruby/public/images/imagenotavailable.png' == url.to_s
#  noavatar =  ( '/home/schwarz/project/foodpal_ruby/public/images/imagenotavailable.png' == url.to_s)
#  puts no_blank.to_s.blue
#  exist =  File.exist?(url)
#  p.update_attributes(image: File.new(url, 'rb'))  if exist && image && url && (image != '') && !noavatar


#users = User.all
#

# users.each do |user|
#
#   #puts user.inspect.red
#   ContactMailer.change_password(user);
# end

#@locations = Location.all
#
#@locations.each do |l|
#  #puts l.phone.inspect
#  if l.phone != "" && l.phone
#    phone = "+1" + l.phone.gsub(/[^0-9]/, "").to_s
#
#    l.phone = phone
#    l.save
#
#    puts ("id: " + l.id.to_s).magenta + (" / phone: " + l.phone).green
#
#  else
#    puts ("id: " + l.id.to_s).magenta + (" / No any number ").red
#  end
#end

#users.each do |user|
#
#  user_info = {"name"=>"name", "email"=>"v@v.v", "message"=>"dfghdfgdfg"}
#  subject = 'Test'
#  #puts user.inspect.red
#  ContactMailer.change_password(user).deliver;;
#  puts 'send ----------------mail----------------'
# #puts  ContactMailer.send_email(user_info, subject).deliver;
#end

#cities = City.all
#
#city_zip = CityZip.all
#
#cities.each do |city|
#  if !CityZip.where(place_name: city.city).blank?
#    city.zip = CityZip.where(place_name: city.city).first
#  else
#    city.zip = 0
#  end
#
#end

require 'net/http'
require 'uri'

proxy_addr = '209.239.112.217'
proxy_port = 8080

@locations = Location.where("id >= 677")

@locations.each do |l|
  puts l.id.to_s.green
  puts l.address.inspect.yellow.bold

  if l.address


    uri = URI('http://maps.googleapis.com/maps/api/geocode/json?sensor=true&address=' + URI.encode(l.address))

    #Net::HTTP.new(uri, nil, proxy_addr, proxy_port)
    #  request = Net::HTTP::Get.new uri
    #Net::HTTP.start(uri.host, uri.port) do |http|
    #
    #  res = http.request request
    #
    #  puts res.body.green

      #jsonArray =  JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
      #
      #latitude = jsonArray["results"][0]["geometry"]["location"]["lat"]
      #longitude = jsonArray["results"][0]["geometry"]["location"]["lng"]
      #puts latitude.to_s.green + " " + longitude.to_s.green
      #puts jsonArray["results"][0]["address_components"][1].to_s.magenta
      #
      #jArray = jsonArray["results"][0]["address_components"]
      #
      #zip = 0
      #
      #jArray.each do |i|
      #
      #    #puts i.inspect.green.bold
      #    zip = i["long_name"] if i["types"][0] = "postal_code"
      #
      #
      #
      #end
      #
      #puts zip.to_s.magenta.bold
      #
      #puts l.update_attributes(:latitude => latitude, :longitude => longitude, :zip => zip)

    #end



    puts uri.inspect.light_blue
#
    res = Net::HTTP.get_response(uri)

    jsonArray =  JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)

    puts jsonArray.inspect.yellow.bold

    latitude = jsonArray["results"][0]["geometry"]["location"]["lat"]

    longitude = jsonArray["results"][0]["geometry"]["location"]["lng"]
    puts latitude.to_s.green + " " + longitude.to_s.green

    puts jsonArray["results"][0]["address_components"][1].to_s.magenta

    zip = 0
    jArray = jsonArray["results"][0]["address_components"]
    jArray.each do |i|

      #puts i.inspect.green.bold
      zip = i["long_name"] if i["types"][0] = "postal_code"

    end

    puts zip.to_s.magenta.bold

    puts l.update_attributes(:latitude => latitude, :longitude => longitude, :zip => zip)


  end


end

