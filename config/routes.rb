require 'sidekiq/web'

Rails.application.routes.draw do
  get 'transactions/create'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :users, only: [:destroy]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'
  resources :billers, only: [:show, :destroy] do
    resources :transactions, only: [:new, :create]
  end
  get 'my_transactions', to: 'transactions#index', as: :my_transactions
  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
  end
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  resources :downloads, only: [:index, :create, :show]
  post 'language/update'
  resources :bills do
    collection do
      post 'generate'
    end
    member do
      post 'pay'
    end
  end
  resources :repayments, only: [:index, :show]

end
