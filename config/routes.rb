Rails.application.routes.draw do
  root "main_map#index"
  get "plots/plots", to: "plots#plots"
  get "plots/hunters", to: "plots#hunters"

  resources :people, only: %i[index show edit update]
  resources :plots, only: %i[index show new create]

  namespace :side_panel do
    resources :plots, only: [:index]
    resources :hunters, only: [:index, :new, :create]
  end

  namespace :api do
    resources :plots, only: %i[show update] do
      collection do
        get "filter", to: "plots_filter#index"
        get "check_cadastral_number"
      end
    end

    scope module: :people do
      resources :people, only: ["index"]
      resources :active_people, only: ["index"]
      resources :archive_people, only: ["index"]
    end
  end
end
