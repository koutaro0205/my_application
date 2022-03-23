Rails.application.routes.draw do
  get '/signup', to: 'users#new'
  root 'home#index'

end
