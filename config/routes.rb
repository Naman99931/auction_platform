Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  get 'approve_request', to: 'home#approve_request'

  patch 'add_details', to: 'home#add_details'

  get 'report_item/:id', to: 'items#report_item', as: 'report_item'

  get 'flag_item/:id/:item_id', to: 'home#flag_item', as: 'flag_item'

  get 'report_user/:id', to: 'home#report_user', as: 'report_user'

  get 'flag_user/:id/:user_id', to: 'home#flag_user', as: 'flag_user'

  get 'all_flagged_comments', to: 'comments#all_flagged_comments'

  get 'all_flagged_items', to: 'items#all_flagged_items'

  get 'all_flagged_users', to: 'home#all_flagged_users'

  get 'remove_flag_item/:id', to: 'items#remove_flag_item', as: 'remove_flag_item'

  get 'remove_flag_user/:id', to: 'home#remove_flag_user', as: 'remove_flag_user'

  get 'remove_flag_comment/:id', to: 'comments#remove_flag_comment', as: 'remove_flag_comment'

  get 'flagged_item_contact_admin/:item_id', to: 'home#flagged_item_contact_admin', as: 'flagged_item_contact_admin'
  
  #action cable :
  mount ActionCable.server => '/cable'

  # get 'comment_reply', to: 'comments#comment_reply'

  get 'home/user_profile', to: 'home#user_profile'

  # post 'reply', to: 'comments#save_reply'


  get 'items/:id/set_alert', to: 'items#set_alert', as: 'set_alert'

  get 'items/:id/end_auction', to: 'items#end_auction', as: 'end_auction'

  get 'user_items/:id', to: 'items#user_items', as: 'user_items'

  get 'home/all_sellers', to: 'home#all_sellers'

  get 'home/all_bidders', to: 'home#all_bidders'

  get 'view_profile/:id', to: 'home#view_profile', as: 'view_profile'

  get 'home/show_notifications', to: 'home#show_notifications'

  get 'success', to: 'payments#success'
  get 'cancel', to: 'payments#cancel'

  get 'items/buy_items', to: 'items#buy_items'

  get 'home/approve_user/:id/:user_id', to: 'home#approve_user', as: 'home_approve_user'

  get 'home/approve_item/:id/:item_id', to: 'home#approve_item', as: 'home_approve_item'
  
  post "payments/create", to: "payments#create"

  get 'flag_comment/:id', to: 'comments#flag_comment', as: 'flag_comment'

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
