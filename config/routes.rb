ActionController::Routing::Routes.draw do |map|
  map.resources :projectareas

  map.resources :dashboard


  map.connect 'cpro_projects/current_projects', :controller => "cpro_projects", :action => "current_projects"

  map.connect 'reviews/current_projects', :controller => "reviews", :action => "current_projects"
  map.connect 'reviews/for_project/:id', :controller => 'reviews', :action => 'index'
  map.resources :reviews

  map.resources :rights

  map.resources :roles


  map.connect '', :controller => "myteam"
  map.connect 'users/change_password', :controller => "users", :action => "change_password"

  map.connect 'projecttracks/import', :controller => "projecttracks", :action => "import"
  map.connect 'projecttracks/show_import', :controller => "projecttracks", :action => "show_import"
  map.connect 'projecttracks/do_import', :controller => "projecttracks", :action => "do_import"
  map.connect 'projecttracks/show_conversion', :controller => "projecttracks", :action => "show_conversion"
  map.connect 'projecttracks/do_conversion', :controller => "projecttracks", :action => "do_conversion"
  
  map.resources :users

  map.resources :cpro_projects

  map.resources :projecttracks

  map.resources :teamcommitments

  map.resources :projects
  
  map.resources :teammembers

  map.resources :countries, :active_scaffold => true

  map.resources :worktypes, :active_scaffold => true

  map.resources :teams, :active_scaffold => true

  map.resources :employees, :active_scaffold => true
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

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
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
