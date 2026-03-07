Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  post '/auth/sign_in'

  post '/api/price_analysis', to: 'price_analysis#create'
  get  '/api/price_analysis', to: 'price_analysis#show'

  post '/api/material_forecast', to: 'material_forecast#create'
  get  '/api/material_forecast', to: 'material_forecast#show'

  scope path: ApplicationResource.endpoint_namespace, defaults: { format: :jsonapi } do
    resources :clients
    resources :materials

    resources :masters do
      resources :schedules, only: %i[index create destroy], controller: "masters/schedules"

      member do
        get :available_dates
        get :available_slots
      end
    end

    resources :services, only: %i[index show create update]
    resources :service_materials, only: %i[index create update destroy]
    resources :service_masters, only: %i[index create destroy]
    resources :users

    namespace :materials do
      post :add, to: 'operations#add'
      post :subtract, to: 'operations#subtract'
    end

    resources :notes, only: %i[index create] do
      member do
        patch :cancel
        patch :complete
      end
    end
  end
end
