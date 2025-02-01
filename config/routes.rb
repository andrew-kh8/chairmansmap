Rails.application.routes.draw do

  root "main_map#index"
  get "plots/plots", to: "plots#plots"
  get "plots/hunters", to: "plots#hunters"

  resources :people, only: %i[index edit update]
  resources :plots, only: %i[index show]

  namespace :side_panel do
    resources :plots, only: [:index]
    resources :hunters, only: [:index, :new, :create]
  end

  namespace :api do
    resources :plots, only: %i[show update] do
      get "filter", to: "plots_filter#index", on: :collection
    end

    scope module: :people do
      resources :people, only: ["index"]
      resources :active_people, only: ["index"]
      resources :archive_people, only: ["index"]
    end
  end
end
