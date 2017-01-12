Rails.application.routes.draw do

  devise_for :users, path: '/'

  devise_scope :user do
    get  '/profile/password', to: 'devise/registrations#edit', as: :user_edit_password
    patch '/profile/password', to: 'devise/registrations#update'
  end

  root to: 'main_pages#index'

end
