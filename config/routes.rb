Rails.application.routes.draw do
  root to: 'companies#index'

  resources :companies do
    resources :users, except: [:show]
  end

  resources :tweets, only: [:index]

  resources :users, param: :username, only: [:index, :show] do
    resources :tweets, only: [:index]
  end
end
