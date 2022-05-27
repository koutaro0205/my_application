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
      get :following, :followers, :favorite_recipes, :interesting_questions
    end
  end
  resources :recipes do
    resources :comments, only: [:create, :destroy]
    collection do
      get :user_favorites, :following_user, :conditional_search
    end
  end
  resources :questions do
    resources :question_comments, only: [:create, :destroy]
    collection do
      get 'search'
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :relationships, only: [:create, :destroy]
  resources :favorites, only: [:create, :destroy]
  resources :categories, except: [:new]
  resources :interests, only: [:create, :destroy]
end
