Rails.application.routes.draw do
  root 'home#index'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/search', to: 'recipes#search'
  get '/short_time', to: 'recipes#short_time'
  get '/low_cost', to: 'recipes#low_cost'
  resources :users do
    member do
      get :following, :followers, :favorite_recipes
    end
  end
  resources :recipes do
    resources :comments, only: [:create, :destroy]
    resources :favorites, only: [:create, :destroy]
    collection do
      get :following
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :relationships, only: [:create, :destroy]
end
