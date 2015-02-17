FoodpalApp::Application.routes.draw do

  get "/404", :to => "errors#not_found"
  get "/422", :to => "errors#unacceptable"
  get "/500", :to => "errors#internal_error"

  get "/errors/not_found"
  get "/errors/internal_error"
  get "/errors/unacceptable"
  get "/errors/unauthorized"

  get "omniauth_callbacks/facebook"

  get "restaurants/new"
  post "restaurants/create"

  match "products/create"

  put "products/update"

  delete "products/delete"

  post "products/edit"
  post "products/get_product"

  get "sendtext/index"
  post "sendtext/send_text_message"
  get "sms" => "receivetext#index"

  match "menus/create"

  put "menus/update"

  delete "menus/delete"
  post "menus/edit"

  match "contact", to: "static_pages#contact", as: "contact"
  match "dispatch_email", to: "static_pages#dispatch_email",
        as: "dispatch_email", method: :post


  post "comments/create"

  delete "gallery/delete"
  post "gallery/create"

  resources :gallery

  post "locations/create"

  post "restaurants/get_cuisine"

  get "restaurants/list"
  get "orders/list"

  post "products/create"

  mount Ckeditor::Engine => '/ckeditor'

  post "restaurants/craving_restaurants"
  post "restaurants/craving_blogs"



  post "cuisines/create"
  delete "cuisines/delete"

  get "orders/index"
  #get "order/:id" => "orders#show"
  resources :orders, only: [:show]
  resources :line_items

  get "locations/get_l_state"
  get "locations/get_l_city"
  get "locations/select_state"
  post "locations/edit"
  put "locations/update"
  delete "locations/delete"

  post "orders/status"
  get "orders/restaurants_orders/:id" => "orders#restaurants_orders"
  resources :carts

  get "restaurants/listing" => "restaurants#listing"

  resources :restaurants, only: [:show, :edit, :destroy, :update]
  #resources :users, only: [:edit]

  post "blogs/create"

  get "cities/index"
  resources :blogs, except: [:create]


  root :to =>  "restaurants#index"

  get "user" => "users#index"
  get "users/list"

  get "restaurants/index"
  post "restaurants/vote"


 post "restaurants/search"
post "restaurants/import_excel"
  post "restaurants/locations_import_excel"

  #get  "/restaurant/:id",   to:  "restaurants#show"

 post 'line_items/remove_item'


  get "about_us"                    => "static_pages#about_us"
  get "careers"                     => "static_pages#careers"
  get "founder_of_foodpal"          => "static_pages#founder"
  get "privacy_policy"              => "static_pages#private_policy"
  get "iphone_mobile_application"   => "static_pages#iphone"
  get "how_foodpal_works"           => "static_pages#how_works"
  get "media_kit"                   => "static_pages#media_kit"

  post "payments/payment"

  #get "blog"                        => "blogs#index"
  #get "/blogs/:id",  to:   'blogs#show'

  get "users/select_country"
  get "users/select_state"
  put "users/update"
  put "users/update"
  put "users/update_user"
  get "users/ready_city"
  get "users/get_user_state"
  get "users/get_user_city"
  put "users/update_password"
  get "users/user_edit"

  post "users/generate_new_password_email"
  #put "users/edit"

  get "receivetext/index"
  post "receivetext/voice"
  #get "receivetext/voice"

  resources :cuisines do
    get :autocomplete_cuisine_name, :on => :collection
  end

    #get "cuisines/autocomplete"

  match '/users/auth/:service/callback' => 'users/services#create'
  resources :services, :only => [:index, :create, :destroy]

  devise_for :users,  :controllers => { :sessions => "admins/sessions", :registrations=> "admins/registrations"},
                                      path_names: { edit_user_registration: "/",
                                      sign_out: "logout" }


  namespace :api do

    namespace :users do
      post "sign_in"

      post "create"
      
      post "sign_up"

      post "destroy"

      post 'orders'

      match "update"

      get "show"
    end

    namespace :orders do
      get "create_cart"
    end

    namespace :restaurants do

      post "search"

      #get "show"

      get "menu"

      get "set_select_params"

      match 'search_by_params'
      match 'search_restaurants'
      match 'get_from_current_location'


      get 'set_menu'
      get 'set_menu_items'
    end

    namespace :menus do
      match "get_menu_list"
    end

    namespace :products do
      match "get_product_list"
    end

    namespace :galleries do
      match "get_photo_list"
      match "get_first_photo"
    end

    namespace :comments do
      match "list"
    end

    namespace :payments do
      match "payment"
    end


    get 'logout' => 'devise/sessions#new'


  end

  # The priority is based upon orders of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admins do
  #     # Directs /admins/products/* to admins::ProductsController
  #     # (app/controllers/admins/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'


end
