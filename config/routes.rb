Rails.application.routes.draw do
  root 'pages#home'
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  get 'contact', to: 'pages#contact'
  get 'about', to: 'pages#about'

  get 'users/new'

  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
