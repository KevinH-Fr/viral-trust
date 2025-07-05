Rails.application.routes.draw do
  get "referral_links/redirect"
  get "pages/home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  #flow login
  post 'flow_auth/authenticate', to: 'flow_auth#authenticate'
  delete 'flow_auth/logout', to: 'flow_auth#logout'
 
  resources :users, only: [:edit, :update]
  resources :campaigns, only: [:new, :create, :show]

  resources :referrals, only: [:create]

  get '/r/:code', to: 'referral_links#redirect', as: :referral_redirect

  root "pages#home"

  namespace :api do
    namespace :referrals do
      post 'track', to: 'tracker#create'
      post "generate", to: "links#create"
    end
  end

  # config/routes.rb
  get '/tracking.js', to: redirect('/assets/public/tracking.js')


end
