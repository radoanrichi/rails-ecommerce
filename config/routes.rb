Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users
  
  # User-specific routes
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
  resource :user, only: %i[show edit update]

  # Main resource routes
  resources :products do
    resources :reviews
    get 'delete_image/:image_id', to: 'products#delete_image', as: :delete_image
  end

  resources :categories
  resources :reviews

  # Cart and shopping routes
  resource :cart, only: :show
  resources :cart_items, only: %i[create update destroy]
  
  resources :carts do
    member do
      post :checkout
    end
    resources :cart_items
  end

  # Order management routes
  resources :orders do
    resources :order_items
    resource :payment
    member do
      get :email_preview
    end
  end

  resources :order_items

  # Admin routes
  namespace :admin do
    resources :products, only: %i[index new create edit update destroy]
    resources :categories, only: %i[index new create edit update destroy]
    resources :users, only: %i[index destroy]
  end

  # Development tools
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq' if Rails.env.development? || Rails.env.production?
end
