Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  #action cable :
  
  mount ActionCable.server => '/cable'

  
  get 'sellers/index', to: 'sellers#index'

  get 'home/user_profile', to: 'home#user_profile'


  get 'items/:id/set_alert', to: 'items#set_alert', as: 'set_alert'

  get 'items/:id/end_auction', to: 'items#end_auction', as: 'end_auction'

  get 'admin/all_sellers', to: 'admin#all_sellers'

  get 'admin/all_bidders', to: 'admin#all_bidders'

  get 'admin/user_items/:id', to: 'admin#user_items', as: 'user_items'

  
  get 'admin/show_notifications', to: 'admin#show_notifications'

  get 'success', to: 'payments#success'
  get 'cancel', to: 'payments#cancel'

  get 'bidders/buy_items', to: 'bidders#buy_items'

  get 'admin/approve_seller/:id/:user_id', to: 'admin#approve_seller', as: 'admin_approve_seller'
  
  post "payments/create", to: "payments#create"

  resources :bidders, only: [:index]

  resources :items

  resources :users do
    resources :items
  end
  
  resources :items do
    resources :bids, only: [:index, :new, :create]
  end

  resources :items do
    resources :comments
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
