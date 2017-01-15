Rails.application.routes.draw do

  devise_for :users, path: '/', only: :omniauth_callbacks,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  scope "(:locale)", locale: /en|ru/ do

    devise_for :users, path: '/', skip: :omniauth_callbacks,
     controllers: { registrations: 'users' }

    devise_scope :user do
      get  'settings', to: 'users#edit', as: :user_edit
      patch '/settings', to: 'users#update', as: :user_update
    end


    root to: 'main_pages#index'

  end

end
