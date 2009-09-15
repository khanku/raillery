ActionController::Routing::Routes.draw do |map|
  map.resources :albums


  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products
#   map.resources :pictures
#   map.resources :browse
  map.resources :users
  map.resources :tweets
  map.resource  :session

  # Sample resource route with options:
#     map.resources :products, :member => { :hort => :get, :toggle => :post }, :collection => { :sold => :get }
  map.resources :pictures, :member => { :terminate => :post }
  map.resources :browse
  map.resources :managers, :collection => { :own => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "browse"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

  # custom routes for authentication
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.signup_ajax '/signup_ajax', :controller => 'users', :action => 'new_ajax'
  map.login  '/login',  :controller => 'sessions', :action => 'new'
  map.login_ajax  '/login_ajax',  :controller => 'sessions', :action => 'new_ajax'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
end
