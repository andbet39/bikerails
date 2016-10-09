Rails.application.routes.draw do
  namespace :api do
  get 'like/like'
  end

  namespace :api do
  get 'like/dislike'
  end

  namespace :api do
  get 'like/getvotes'
  end

  get 'like/like'

  get 'like/dislike'

  get 'like/getvotes'

  resources :participations


  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :ride_types
  resources :ride_levels
  get 'hello_world', to: 'hello_world#index'
  get 'my_meeting/index'

  get 'my_meeting/create'

  get 'my_meeting/view'
  get 'my_meeting/search'

  resources :meetings
  namespace :api do
    get 'strava_segment/getForTrack'
    post 'track/import'
    get 'track/elaborate'
    get 'meeting/search'
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



  # You can have the root of your site routed with "root"
   root 'my_meeting#search'


end
