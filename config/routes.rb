Rails.application.routes.draw do
  devise_for :users
  resources :users, except: %i[index new create]
  resources :favorites, only: %i[create destroy]
  resources :restaurants, only: %i[show index]
  root to: 'pages#home'
  get '/about', to: 'pages#about'
  get '/contact', to: 'pages#contact'
  get '/load', to: 'restaurants#load'
  get '/verify', to: 'restaurants#verify'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
