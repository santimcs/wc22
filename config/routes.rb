Rails.application.routes.draw do
  resources :standings
  resources :results
  resources :fixtures
  resources :channels
  resources :criteria
  resources :teams
  # get 'pages/home'
  root 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
