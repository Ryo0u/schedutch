Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :events, only: [:create, :show, :destroy] do
        resources :users, only: [:create]
      end
    end
  end
end