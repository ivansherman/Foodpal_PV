# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140331074414) do

  create_table "addresses", :force => true do |t|
    t.integer  "city_id"
    t.string   "address"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  add_index "addresses", ["city_id"], :name => "index_addresses_on_city_id"

  create_table "blogs", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.text     "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "blogs", ["user_id"], :name => "index_blogs_on_user_id"

  create_table "carts", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "session_id"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "menu_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "categories", ["menu_id"], :name => "index_categories_on_menu_id"

  create_table "cities", :force => true do |t|
    t.string   "city"
    t.integer  "zip"
    t.integer  "state_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "cities", ["state_id"], :name => "index_cities_on_state_id"

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "restaurant_id"
    t.text     "comment"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "blog_id"
  end

  add_index "comments", ["restaurant_id"], :name => "index_comments_on_restaurant_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "countries", :force => true do |t|
    t.string   "iso2"
    t.string   "iso3"
    t.string   "short_name"
    t.string   "long_name"
    t.integer  "num_code"
    t.string   "un_member"
    t.string   "calling_code"
    t.string   "cctld"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "cuisines", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "restaurant_id"
  end

  create_table "cuisines_restaurants", :force => true do |t|
    t.integer "cuisine_id"
    t.integer "restaurant_id"
  end

  create_table "galleries", :force => true do |t|
    t.integer  "restaurant_id"
    t.string   "title"
    t.string   "photo_order"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "galleries", ["restaurant_id"], :name => "index_galleries_on_restourant_id"

  create_table "line_items", :force => true do |t|
    t.integer  "product_id"
    t.integer  "cart_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "quantity",   :default => 1
  end

  create_table "locations", :force => true do |t|
    t.integer  "restaurant_id"
    t.string   "branch"
    t.string   "address"
    t.integer  "city_id"
    t.string   "phone"
    t.string   "delivery_fee"
    t.string   "delivery_time"
    t.string   "latitude"
    t.string   "longitude"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "state_id"
    t.integer  "zip"
  end

  add_index "locations", ["city_id"], :name => "index_locations_on_city_id"
  add_index "locations", ["restaurant_id"], :name => "index_locations_on_restaurant_id"

  create_table "menus", :force => true do |t|
    t.string   "name"
    t.integer  "restaurant_id"
    t.string   "start_time"
    t.string   "end_time"
    t.text     "description"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "menus", ["restaurant_id"], :name => "index_menus_on_restaurant_id"

  create_table "order_items", :force => true do |t|
    t.integer  "product_id"
    t.integer  "order_id"
    t.integer  "count"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "order_items", ["order_id"], :name => "index_order_items_on_order_id"
  add_index "order_items", ["product_id"], :name => "index_order_items_on_product_id"

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.string   "totalprice"
    t.boolean  "delivery_type"
    t.boolean  "payment_method"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "phone"
    t.text     "instructions"
    t.boolean  "napkins"
    t.boolean  "condiments"
    t.string   "delivery_date"
    t.string   "delivery_time"
    t.integer  "transaction_id"
    t.string   "address"
    t.integer  "location_id"
    t.string   "status_id"
    t.string   "success_key"
    t.string   "cancel_key"
  end

  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "payments", :force => true do |t|
    t.string   "status"
    t.float    "amount"
    t.string   "transaction_number"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "picture"
    t.string   "price"
    t.integer  "menu_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "products", ["menu_id"], :name => "index_products_on_category_id"

  create_table "ratings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "restaurant_id"
    t.integer  "value"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "ratings", ["restaurant_id"], :name => "index_ratings_on_restaurant_id"
  add_index "ratings", ["user_id"], :name => "index_ratings_on_user_id"

  create_table "restaurants", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "logo"
    t.integer  "delivery_type"
    t.integer  "payment_type"
    t.string   "facebook_url"
    t.string   "twitter_url"
    t.string   "g_url"
    t.string   "miny_order"
    t.string   "tax"
    t.boolean  "active"
    t.datetime "entry_date"
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.float    "rating"
    t.string   "url"
    t.boolean  "list"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "restaurants", ["user_id"], :name => "index_restaurants_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "services", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "uname"
    t.string   "uemail"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.integer  "user_id"
    t.string   "auth_token"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["user_id"], :name => "index_sessions_on_user_id"

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "simple_captcha_data", ["key"], :name => "idx_key"

  create_table "states", :force => true do |t|
    t.integer  "country_id"
    t.string   "state"
    t.string   "state_code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "states", ["country_id"], :name => "index_states_on_country_id"

  create_table "statuses", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "color"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
    t.string   "login"
    t.string   "phone"
    t.string   "image"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "new_pass"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
