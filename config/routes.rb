Rails.application.routes.draw do
  devise_for :managers

  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :transactions, only: :create

  
  root to: "users#index"
end
