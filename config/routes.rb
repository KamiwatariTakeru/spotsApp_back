Rails.application.routes.draw do
  resources :likes
  # resources :auth_infos
  # resources :evaluations
  resources :users
  resources :spots
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  post "get_evaluation_Record" => "evaluations#getEvaluationRecord"
  get "evaluate_spot" => "spots#evaluate"
  get "search_spot" => "spots#search", as: :searchSpots
  get 'spots/getCoordinate/:id', to: "spots#getCoordinate", as: :get_coordinate
  post 'auth/:provider/callback', to: "users#create"
  get 'users/get_current_user/:uid', to: "users#getCurrentUser", as: :get_current_user
end
