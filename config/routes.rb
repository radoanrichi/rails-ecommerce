Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users
  resource :cart, only: :show
  resources :cart_items, only: %i[create update destroy]
  resources :users do
    resource :cart do
      member do
        post 'checkout'
      end
      resources :cart_items
    end
    resources :orders
  end

  get 'users/all_users', to: 'users#all_users', as: :all_users

  resources :products do
    resources :reviews
  end

  resources :reviews
  resources :categories

  resources :orders do
    resources :order_items
  end

  resources :carts do
    member do
      post :checkout
    end
  end

  resources :order_items

  resources :carts do
    resources :cart_items
  end

  resources :cart_items

  resources :orders do
    resource :payment
  end

  resources :orders do
    member do
      get :email_preview
    end
  end

  resource :user, only: %i[show edit update]

  namespace :admin do
    resources :products, only: %i[index new create edit update destroy]
    resources :categories, only: %i[index new create edit update destroy]
    resources :users, only: %i[index destroy]
  end

  resources :products do
    get 'delete_image/:image_id', to: 'products#delete_image', as: :delete_image
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  require 'sidekiq/web'

  # Mount Sidekiq's web interface at /sidekiq
  mount Sidekiq::Web => '/sidekiq' if Rails.env.development? || Rails.env.production?
end
