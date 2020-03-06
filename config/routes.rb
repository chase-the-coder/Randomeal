Rails.application.routes.draw do
  get 'restaurants/show'
  devise_for :users
  resources :users, except: %i[index new create]
  resources :restaurants, only: :show
  root to: 'pages#home'
  get '/about', to: 'pages#about'
  get '/contact', to: 'pages#contact'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
