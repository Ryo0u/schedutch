Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :tests, only: [:index]
      
      resources :events, only: [:create, :show]
    end
  end
end