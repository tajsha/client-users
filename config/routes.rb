Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users
  resources :users do
    get :map_result
  end
end
