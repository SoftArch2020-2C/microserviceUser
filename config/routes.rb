Rails.application.routes.draw do
  # devise_for :users
  namespace :api do
    namespace :v1 do
      resources :users
      resources :sessions, only: [:create,:destroy]
    end
  end
  #/api/v1/users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
