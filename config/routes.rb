Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  
  root "survey_responses#index"

  get "survey_responses/export", controller: "survey_responses", action: "export"
  get "about", controller: "static", action: "about"
  
  resources :survey_responses
  resources :codebooks do
    post "enqueue_categories", action: "enqueue_categories"
  end
  resources :questions
  
end
