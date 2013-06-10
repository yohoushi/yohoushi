Yohoushi::Application.routes.draw do
  resources :graphs

  root 'graphs#list_graph'
  get 'list_graph' => 'graphs#list_graph', :as => 'list_graph_root'
  get 'list_graph/:path' => 'graphs#list_graph', :constraints => { :path => /.+/ }, :as => 'list_graph'
  get 'view_graph/:path' => 'graphs#view_graph', :constraints => { :path => /.+/ }, :as => 'view_graph'

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
