Rails.application.routes.draw do

  resource :session, only: [:create, :destroy]
  get '/sign-up', to: 'users#new', as: :sign_up
  get "/amazon_products/sitemap"

  namespace :admin do
    root 'products#index'
    resources :products do
      member do
        patch :setting_cover, :publish_operation
      end
    end
    resources :product_pictures
    resources :messages, except: [:show, :new, :create] 
    resources :users do
      delete :destroy_user_picture, on: :member
    end
    resources :product_categories
    resources :evaluates
  end

  %w( 404 422 500 ).each do |code|
    get code, to: "errors#show", code: code
  end

  resources :products, only: [:index, :show] do

    resources :messages, only: [:index, :create, :destroy] do
      collection do
        post :create_evaluate_message
      end
    end
    resources :evaluates
    resource :collectionship, only: [:create, :destroy]
    
  end
  resource :likeship, only: [:create, :destroy]
  
  resources :users, only: [:index, :show, :create] do
    member do
      get :all_evaluates
    end
  end

  resource :account, only: [:edit, :update] do
    collection do
      get :change_password
      patch :update_password, :setting_cover
    end
    resources :user_pictures, only: [:index, :show, :create, :destroy]
  end

  resources :notifications, only: [:index, :destroy]
  resources :amazon_products, only: [:index, :show]

  root 'products#index'
end
