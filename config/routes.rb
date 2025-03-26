Rails.application.routes.draw do
  root 'plots#index'
  get 'plots/plots', to: 'plots#plots'
  get 'plots/hunters', to: 'plots#hunters'

  resources :people, only: %i[index edit update]

  namespace :api do
    resources :plots, only: %i[show update] do
      get 'filter', to: 'plots_filter#index', on: :collection
    end

    scope module: :people do
      resources :people, only: ['index']
      resources :active_people, only: ['index']
      resources :archive_people, only: ['index']
    end
  end
end
