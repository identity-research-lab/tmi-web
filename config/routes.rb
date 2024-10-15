Rails.application.routes.draw do
  resources :trashes
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  root "survey_responses#index"

  get "about", controller: "static", action: "about"

  resources :codebooks do
    post "enqueue_categories", action: "enqueue_categories"
  end

  resources :survey_responses do
    post "enqueue_keywords", action: "enqueue_keywords"
  end

  resources :annotations
  resources :questions
  resources :stats
  resources :themes

end
