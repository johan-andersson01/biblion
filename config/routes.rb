Rails.application.routes.draw do
  get 'sessions/new'

  root 'pages#home'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/contact', to: 'pages#contact'
  get '/about', to: 'pages#about'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end