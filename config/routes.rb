# typed: false

Rails.application.routes.draw do
  root "main_map#index"
  get "plots/plots", to: "plots#plots"
  get "plots/hunters", to: "plots#hunters"

  resource :maintenance, only: :show

  resources :people, only: %i[index show edit update]
  resources :plots, only: %i[index show new create destroy]

  namespace :side_panel do
    resources :plots, only: [:index, :show, :edit, :update]
    resources :hunters, only: [:index, :new, :create, :destroy]
  end

  namespace :api do
    namespace :plots do
      get "filter", to: "/api/plots_filter#index"
      get "check_cadastral_number"
    end
  end

  namespace :geometry do
    resources :hunters, only: [:index]
    resources :plots, only: [:index, :show]
  end
end
