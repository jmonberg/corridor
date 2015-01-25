ActionController::Routing::Routes.draw do |map|
  map.resources :abuses

  map.connect '/maps/improvement', :controller => 'maps', :action=>'improvement'
  map.connect '/maps/highlight', :controller => 'maps', :action=>'highlight'
  map.connect 'maps/story', :controller => 'maps', :action=>'story'
  map.connect 'maps/article', :controller => 'maps', :action=>'article'
  
  map.resources :maps, :member => {:abuse => :put} do |maps|
    maps.resources :comments
    maps.resources :taggs
  end
  
  map.resources :stories, :has_many => :comments, :member => {:abuse => :put}
  map.resources :stories, :has_many => :taggs

  map.resources :taggs, :collection => {:search => :get}

  map.resources :images, :collection => {:categories => :get} do |images|
    images.resources :taggs
    images.resources :comments
  end

  map.resources :totem_events
  
  map.connect '/articles/cooperation',    :controller => 'articles', :action=>'cooperation'
  map.connect '/articles/environmental',  :controller => 'articles', :action=>'environmental'
  map.connect '/articles/business',       :controller => 'articles', :action=>'business'
  map.connect '/articles/transportation', :controller => 'articles', :action=>'transportation'
  map.connect '/articles/streetscape',    :controller => 'articles', :action=>'streetscape'
  map.connect '/articles/densemixeduse',  :controller => 'articles', :action=>'densemixeduse'

  map.resources :articles, :member => {:abuse => :put} do |articles|
    articles.resources :comments
    articles.resources :votes
    articles.resources :taggs
  end

  map.resources :stories, :has_many => :taggs
  map.resources :feeds do |feeds|
    feeds.resources :feed_articles do |feed_articles|
      feed_articles.resources :comments
    end
  end

  map.resources :comments, :member => {:abuse => :put}

  map.resources :feed_articles do |feed_article|
    feed_article.resources :taggs
    feed_article.resources :comments
  end
  map.resource :account, :controller => "users"
  map.resources :users
  map.resource :user_session
  
  # map.root :controller => "user_sessions", :action => "new"
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
  map.root :controller => 'site', :action => 'index'

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
