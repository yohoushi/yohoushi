Yohoushi::Application.routes.draw do
  root 'graphs#tree_graph'

  get 'tree_graph' => 'graphs#tree_graph', :as => 'tree_graph_root'
  get 'tree_graph/:path' => 'graphs#tree_graph', :constraints => { :path => /.+/ }, :as => 'tree_graph'
  get 'view_graph/:path' => 'graphs#view_graph', :constraints => { :path => /.+/ }, :as => 'view_graph'
  get 'setup_graph/:path' => 'graphs#setup_graph', :constraints => { :path => /.+/ }, :as => 'setup_graph'
  get 'list_graph' => 'graphs#list_graph', :as => 'list_graph_root'
  get 'list_graph/:path' => 'graphs#list_graph', :constraints => { :path => /.+/ }, :as => 'list_graph'
  get 'tag_graph' => 'graphs#tag_graph', :as => 'tag_graph_root'
  get 'tag_graph/:tag_list' => 'graphs#tag_graph', :constraints => { :tag_list => /.+/ }, :as => 'tag_graph'
  get 'autocomplete_graph' => 'graphs#autocomplete_graph', :as => 'autocomplete_graph'
  get 'tagselect_graph' => 'graphs#tagselect_graph', :as => 'tagselect_graph'
  get 'accordion_graph' => 'graphs#accordion_graph', :as => 'accordion_graph'

  # NOTE: Implementation of following proxy routes are at config/application.rb, not graphs_controller.rb
  get 'graph/:path' => 'graphs#proxy_graph', :constraints => { :path => /.+/ }, :as => 'proxy_graph'
  get 'complex/:path' => 'graphs#proxy_complex', :constraints => { :path => /.+/ }, :as => 'proxy_complex'

  namespace :debug, :as => '', :path => '' do
    resources :graphs
  end

  namespace :api do
    resources :graphs, :only => %w[index], :constraints => { :path => /.+/ }, :defaults => {:format => 'json'} do
      collection do
        post   ':path' => 'graphs#create'
        get    ':path' => 'graphs#show'
        put    ':path' => 'graphs#update'
        delete ':path' => 'graphs#destroy'
      end
    end
    resources :complexes, :only => %w[index], :constraints => { :path => /.+/ }, :defaults => {:format => 'json'} do
      collection do
        post   ':path' => 'complexes#create'
        get    ':path' => 'complexes#show'
        put    ':path' => 'complexes#update'
        delete ':path' => 'complexes#destroy'
      end
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
