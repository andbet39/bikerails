Rails.application.routes.draw do
  devise_for :users
  resources :ride_types
  resources :ride_levels
  get 'hello_world', to: 'hello_world#index'
  get 'my_meeting/index'

  get 'my_meeting/create'

  get 'my_meeting/view'

  resources :meetings
  namespace :api do
    get 'strava_segment/getForTrack'
    post 'track/import'
    get 'track/elaborate'
  end

  namespace :api do
  get 'strava_segment/getForBounds'
  end

  get 'hello_world', to: 'hello_world#index'
  get 'your_track/index'

  get 'your_track/view'
  get 'your_track/viewjs'

  resources :points
  resources :tracks
  get 'track_import/index'
  get 'track_import/viewjson'
  get 'track_import/getrealelevation'

  post 'track_import/import'
  post 'track_import/importfit'

  get 'track_import/view'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'welcome#index'

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
