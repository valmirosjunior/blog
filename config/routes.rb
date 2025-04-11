Rails.application.routes.draw do
  root to: 'companies#index'

  resources :companies do
    resources :users, only: [:index, :new, :create]
  end

  resources :tweets, only: [:index]

  resources :users, param: :username, only: [:index, :show] do
    resources :tweets, only: [:index]
  end
end
