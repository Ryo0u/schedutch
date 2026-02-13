Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :events, only: [:create, :show, :destroy] do
        resources :users, only: [:create]
      end
      
      resources :users, only: [:update, :destroy] do
        member do
          post :authenticate
        end
      end
    end
  end
end