Rails.application.routes.draw do

  devise_for :users, path: '/', only: :omniauth_callbacks,
    controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  scope '(:locale)', locale: /en|ru/ do

    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

    devise_for :users, path: '/', skip: :omniauth_callbacks,
      controllers: { registrations: 'users', sessions: 'sessions' }

    devise_scope :user do
      resource :user, only: [:edit, :update], path_names: { edit: '' },
        path: 'settings'
    end

    resources :books, only: [:index, :show, :update]
    resources :order_items, only: [:create, :destroy]

    resource :cart, only: [:edit, :update], path_names: { edit: '' },
      path: 'cart'

    resources :checkouts, only: [:show, :update]
    resources :orders, only: [:index, :show, :update]

    root to: 'main_pages#index'

  end

end
