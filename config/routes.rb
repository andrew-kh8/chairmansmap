# typed: false

require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  concern :cadastral_number do
    get :check_cadastral_number, on: :collection
  end

  root "main_map#index"
  get "plots/plots", to: "plots#plots"
  get "plots/hunters", to: "plots#hunters"

  resource :maintenance, only: :show

  resources :people, only: %i[index show edit update]
  resources :plots, only: %i[index show new create destroy], concerns: :cadastral_number
  resources :villages, only: [:index, :show, :new, :create], concerns: :cadastral_number do
    resource :agromonitoring, only: [:create, :destroy] do
      post :add_tiles, on: :member
    end
  end

  namespace :side_panel do
    resources :plots, only: [:index, :show, :edit, :update]
    resources :hunters, only: [:index, :new, :create, :destroy]
  end

  namespace :api do
    namespace :plots do
      get "filter", to: "/api/plots_filter#index"
    end
  end

  namespace :geometry do
    resources :hunters, only: [:index]
    resources :plots, only: [:index, :show]
    resources :villages, only: [:show] do
      resources :plots, only: [:index], controller: "villages/plots"
    end
  end
end
