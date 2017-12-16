Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

  root 'pages#home'
  #pages
  get '/about',     to: 'pages#about'
  post 'search',    to: 'books#search_book'
  #users
  get '/signup',    to: 'users#new'
  post '/signup',   to: 'users#create'
  get '/users',     to: 'users#index'
  #books
  get 'search',     to: 'books#search_book'
  get 'author',     to: 'books#all_by_author'
  get 'location',   to: 'books#all_by_location'
  get 'landscape',  to: 'books#all_by_landscape'
  get 'genre',      to: 'books#all_by_genre'
  get 'tag',        to: 'books#all_by_tag'
  get 'books/new',  to: 'books#new'
  post 'books/new', to: 'books#create'
  get 'books/add',  to: 'books#add'
  post 'books/add', to: 'books#googlebooks_search'
  #session
  get '/login',     to: 'sessions#new'
  post '/login',    to: 'sessions#create'
  delete 'logout',  to: 'sessions#destroy'

  resources :users
  resources :books
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
end
