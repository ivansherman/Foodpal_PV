class Restaurant < ActiveRecord::Base

  #has_and_belongs_to_many :cuisines
  has_many :cuisines, dependent: :destroy
  belongs_to :user
  has_many :locations, dependent: :destroy
  has_many :menus, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :galleries, dependent: :destroy
  has_many :orders


  validates_presence_of :name

  attr_accessible :active, :delivery_type, :description, :email, :entry_date, :facebook_url, :g_url, :logo, :miny_order, :name, :payment_type, :tax, :twitter_url, :image, :url, :rating, :list

  has_attached_file :image,
                    :url  => "/uploads/images/restaurant/:id/:style/:filename.:extension",
                    :default_url => "/assets/imagenotavailable.png",
                    :path => ":rails_root/public/uploads/images/restaurant/:id/:style/:filename.:extension",
                    :styles => { :medium => "300x300>", :thumb => "100x100>" }

  def self.import_from_excel(import_file, rest, format)
    Spreadsheet.client_encoding = 'UTF-8'



    temp = Tempfile.new([import_file.original_filename, format ])
    temp.binmode
    temp.write(import_file.read)
    temp.close


    oo = (format == '.xls')? Roo::Excel.new("#{temp.path}") : Roo::Excelx.new("#{temp.path}")



    oo.default_sheet = oo.sheets.first

    new_menu = {}

    new_product = {}
    product_col = 0
    menu_col = 0
    description_col = 0
    price_col = 0
    menu = {}

    row_size = oo.last_row
    col_size = oo.last_column

    puts row_size.inspect.red
    puts col_size.inspect.red

    1.upto(col_size) do |i|
      #puts oo.cell(1,i)
      if (oo.cell(1,i).match(/.enu .ame/))
        puts oo.cell(1,i)
        menu_col = i
      end
      if (oo.cell(1,i).match(/.roduct .ame/))
        puts oo.cell(1,i).to_s.blue
        product_col = i
      end
      if (oo.cell(1,i).match(/.roduct .escription/))
        puts oo.cell(1,i).to_s.red.bold
        description_col = i
      end
      if (oo.cell(1,i).match(/.rice/))
        puts oo.cell(1,i).to_s.green.bold
        price_col = i
      end
    end

    2.upto(row_size) do |row|
      if (oo.cell(row,menu_col))
        menu[oo.cell(row,menu_col)] = row

      end
    end
    menu.each do |rest_menu|
      #puts rest_menu[0]
      #puts rest_menu[1]
      i = 0
      0.upto(menu.length) do |num|
        i = num if menu.keys[num] == rest_menu[0]
      end
      puts '---------num'.red
      #i = menu.keys[rest_menu[0]]
      start_row =  menu[menu.keys[i]].to_i
      end_row =  menu.keys[i+1]?  menu[menu.keys[i+1]] : (row_size +1)

      menu_created = rest.menus.create(name: rest_menu[0] )
      start_row.upto(end_row -1 ) do |i|
        pr_name =  oo.cell(i,product_col) if oo.cell(i,product_col)
        pr_descripotion =  oo.cell(i,description_col) if oo.cell(i, description_col)
        pr_price = oo.cell(i,price_col).to_f if oo.cell(i,price_col)

        menu_created.products.create(name: pr_name, description: pr_descripotion, price: pr_price ) if oo.cell(i,product_col)

      end

      #this.menus.create(name: rest_menu[0])
      #for i in  (rest_menu[1]..)

      #end
    end
    #puts    product_col.to_s.green
    #puts     menu_col.to_s.green
    #puts     description_col.to_s.green
    #puts     price_col.to_s.green
    #puts    menu.inspect.red

  end


  def self.import_r_from_excel(import_file, format)
    puts import_file.inspect.magenta

    Spreadsheet.client_encoding = 'UTF-8'



    temp = Tempfile.new([import_file.original_filename, format ])
    temp.binmode
    temp.write(import_file.read)
    temp.close


    oo = open_spreadsheet(temp, format)



    oo.default_sheet = oo.sheets.first

    new_restaurant = {}

    new_location = {}

    name_col = 0
    market_col = 0
    address_col = 0
    phone_col = 0
    web_col = 0
    email_col = 0
    delivery_col = 0
    tax_col = 0

    restaurant = {}

    row_size = oo.last_row
    col_size = oo.last_column

    puts row_size.inspect.red
    puts col_size.inspect.red

    1.upto(col_size) do |i|
      #puts oo.cell(1,i)
      if (oo.cell(1,i).match(/.estaurant .ame/))
        puts oo.cell(1,i)
        name_col = i
      end
      if (oo.cell(1,i).match(/.ales .arket/))
        puts oo.cell(1,i).to_s.blue
        market_col = i
      end
      if (oo.cell(1,i).match(/.mail/))
        puts oo.cell(1,i).to_s.green.bold
        email_col = i
      end
      if (oo.cell(1,i).match(/.ddress/))
        puts oo.cell(1,i).to_s.red.bold
        address_col = i
      end
      if (oo.cell(1,i).match(/.hone/))
        puts oo.cell(1,i).to_s.green.bold
        phone_col = i
      end
      if (oo.cell(1,i).match(/.ebsite/))
        puts oo.cell(1,i).to_s.green.bold
        web_col = i
      end

      if (oo.cell(1,i).match(/.elivery\/.ick-.p/))
        puts oo.cell(1,i).to_s.green.bold
        delivery_col = i
      end
      if (oo.cell(1,i).match(/.ales .ax/))
        puts oo.cell(1,i).to_s.green.bold
        tax_col = i
      end
    end

    2.upto(row_size) do |row|
      if (oo.cell(row,name_col))
        restaurant[row] = oo.cell(row,name_col)

      end
    end

    #puts restaurant.inspect.blue.bold
    restaurant.each do |r, i|



      #puts ((i + 2).to_s + ': ' + restaurant.keys[i].to_s).yellow



      res = Restaurant.find_by_name(i)
      puts (r.to_s.to_s + ': ' + i).yellow.bold + " - " + res.name.magenta.bold if res
      puts (r.to_s.to_s + ': ' + i).red.bold unless res


      if (res)
        r_name = i
        r_market = oo.cell(r,market_col) if oo.cell(r, market_col)
        #puts market_col.to_s.light_blue
        r_address = oo.cell(r,address_col) if oo.cell(r, address_col)
        #puts r_address.inspect.red
        r_phone = oo.cell(r,phone_col) if oo.cell(r, phone_col)
        r_url = oo.cell(r,web_col) if oo.cell(r, web_col)
        r_email = oo.cell(r,email_col) if oo.cell(r, email_col)
        d = oo.cell(r,delivery_col) if oo.cell(r, delivery_col)

        if d.equal?("Pick up,")
          r_delivery_type = 1
        elsif d.equal?("Delivery,")
          r_delivery_type = 2
        else
          r_delivery_type = 0
        end


        r_tax = oo.cell(r,tax_col) if oo.cell(r, tax_col)

        r_city = City.find_by_city(r_market)
        #puts r_city.inspect.light_blue

        hash = {
            restaurant: {
                name: r_name,
                delivery_type: r_delivery_type,
                tax: r_tax,
                email: r_email,
                url: r_url
            },
            location: {
                restaurant_id: res.id,
                address: r_address,
                city_id: r_city.id,
                phone: r_phone
            }
        }

        #puts hash.inspect.green

        if res.update_attributes(hash[:restaurant])
          #puts res.id.to_s.green

          location = res.locations.new(hash[:location])

          #puts location.inspect.blue.bold

          if location.save
            puts location.address.green
          else
            puts location.address.red
          end
        #
        else
          puts rest.name.red
        end
      end



      #menu_created = rest.menus.create(name: rest_menu[0] )
      #start_row.upto(end_row -1 ) do |i|
      #  pr_name =  oo.cell(i,product_col) if oo.cell(i,product_col)
      #  pr_descripotion =  oo.cell(i,description_col) if oo.cell(i, description_col)
      #  pr_price = oo.cell(i,price_col).to_f if oo.cell(i,price_col)
      #
      #  menu_created.products.create(name: pr_name, description: pr_descripotion, price: pr_price ) if oo.cell(i,product_col)

      end


  end

  def self.open_spreadsheet(file, format)
    case (format)
      when ".csv" then Roo::Csv.new("#{file.path}")
      when ".xls" then Roo::Excel.new("#{file.path}")
      when ".xlsx" then Roo::Excelx.new("#{file.path}")
      else raise "Unknown file type: #{format}"
    end
  end

end
