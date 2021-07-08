Rails.application.routes.draw do
  devise_for :managers

  resources :users, only: [:index,:new,:create,:edit,:update]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html


  root to: "users#index"
end
