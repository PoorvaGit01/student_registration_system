require "sidekiq/web"
Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  namespace :admin do
    resources :students do
      collection do
        get :new_import
        post :import
      end
    end
  end

  devise_for :students, controllers: {
    registrations: 'students/registrations',
    sessions: 'students/sessions'

  }

  authenticate :admin_user do
    mount Sidekiq::Web, at: '/sidekiq'
  end

  # devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :students, only: [:show]

  # Defines the root path route ("/")
  # root "posts#index"
  root "students#index"
end
