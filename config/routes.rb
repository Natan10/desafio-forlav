Rails.application.routes.draw do
  devise_for :managers

  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :transactions, only: :create

  namespace :api,defaults: {format: :json} do 
    scope module: :v1 do
      get "/movements/:user_id/balance", to: "movements#balance"
      post "/movements/transaction", to: "movements#transaction"
    end 
  end

  
  root to: "users#index"
end
