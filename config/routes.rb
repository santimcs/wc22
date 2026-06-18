Rails.application.routes.draw do
  root 'pages#home'
  resources :fixtures  # This line should be present
  resources :teams
  resources :standings
  resources :results
  resources :criteria
  resources :channels
  
  get "/list_fixtures", to: 'fixtures#list_fixtures'
end