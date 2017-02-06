Rails.application.routes.draw do

  devise_for :users, path: '/', only: :omniauth_callbacks,
    controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  scope '(:locale)', locale: /en|ru/ do

    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

    devise_for :users, path: '/', skip: :omniauth_callbacks,
      controllers: { registrations: 'users', confirmations: 'confirmations' }

    devise_scope :user do
      resource :user, path_names: { edit: '' }, path: 'settings'
      patch 'confirmation', to: 'confirmations#update', as: :update_user_confirmation
      get "sign_up/(:type)", to: 'users#new', as: :sign_up
      post "sign_up/(:type)", to: 'users#create'
    end

    resources :books, only: [:index, :show, :update]
    resources :order_items, only: [:create, :destroy]

    resource :cart, only: [:edit, :update], path_names: { edit: '' },
      path: 'cart'

    resources :checkouts, only: [:show, :update]
    resources :orders, only: [:index, :show, :update]

    get "home/(:category)", to: 'main_pages#home', as: :home
    root to: 'main_pages#home'

  end

end
