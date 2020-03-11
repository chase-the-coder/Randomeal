Rails.application.routes.draw do
  devise_for :users
  resources :users, except: %i[index new create]
  resources :restaurants, only: [:show, :index]
  root to: 'pages#home'
  get '/about', to: 'pages#about'
  get '/contact', to: 'pages#contact'
  get '/load', to: 'restaurants#load'
  get '/check_result', to: 'restaurants#check_result'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
