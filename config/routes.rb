Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations", omniauth_callbacks: "users/omniauth_callbacks" }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html


  resources :users, only: [ :index, :show ]

  resources :users do
    resources :followings
    resources :followers
    resources :follow_requests
  end

  post "/follows/new", to: "users#index"

  resources :follows

  resources :posts do
    resources :comments, only: [ :index ]
    resources :likes, only: [ :index, :destroy ]
  end

  resources :comments do
    resources :likes, only: [ :index, :destroy ]
  end

  resources :likes, only: [ :new, :create, :destroy ]
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "posts#index"
end
