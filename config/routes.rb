Rails.application.routes.draw do
  root to: 'main_pages#index'

  devise_for :users
end
