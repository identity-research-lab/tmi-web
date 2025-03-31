Rails.application.routes.draw do
  resources :trashes
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  root "cases#index"

  get "about", controller: "static", action: "about"

  resources :dimensions do
    resources :categories
    post "enqueue_category_suggestions", action: "enqueue_category_suggestions"
  end

  resources :annotations
  resources :codebooks
  resources :questions
  resources :responses
  resources :statistics
  resources :themes

  resources :cases do
    post "enqueue_keywords", action: "enqueue_keywords"
  end


end
