Rails.application.routes.draw do

  devise_for :users, path: '/', controllers: {
    registrations: 'registrations',
    omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    get  '/profile/password', to: 'registrations#edit', as: :user_edit_password
    patch '/profile/password', to: 'registrations#update'
  end

  root to: 'main_pages#index'

end
