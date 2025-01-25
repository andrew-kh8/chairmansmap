Rails.application.routes.draw do
  resources :plot, only: %i[show update] do
    get 'filter', to: 'plot_filter#index', on: :collection
  end

  resources :person, only: %i[index edit update] do
    get 'actived', to: 'person#actived', on: :collection
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'plot#index'
end
