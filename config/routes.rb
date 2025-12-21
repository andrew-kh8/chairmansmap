Rails.application.routes.draw do
  root "main_map#index"
  get "plots/plots", to: "plots#plots"
  get "plots/hunters", to: "plots#hunters"

  resource :maintenance, only: :show

  resources :people, only: %i[index show edit update]
  resources :plots, only: %i[index show new create destroy] do
    get :geometry
  end

  namespace :side_panel do
    resources :plots, only: [:index, :show, :edit, :update]
    resources :hunters, only: [:index, :new, :create]
  end

  namespace :api do
    namespace :plots do
      get "filter", to: "/api/plots_filter#index"
      get "check_cadastral_number"
    end
  end
end
