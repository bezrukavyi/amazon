Rails.application.routes.draw do

  devise_for :users, path: '/', only: :omniauth_callbacks,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  scope "(:locale)", locale: /en|ru/ do

    devise_for :users, path: '/', skip: :omniauth_callbacks,
     controllers: { registrations: 'registrations' }

    devise_scope :user do
      get  '/profile/password', to: 'registrations#edit', as: :user_edit_password
      patch '/profile/password', to: 'registrations#update'
    end

    root to: 'main_pages#index'

  end

end
