Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  post '/auth/sign_in'

  scope path: ApplicationResource.endpoint_namespace, defaults: { format: :jsonapi } do
    resources :materials

    resources :masters do
      resources :schedules, only: %i[index create destroy], controller: "masters/schedules"
    end

    resources :services
    resources :service_materials
    resources :service_masters
    resources :users

    namespace :materials do
      post :add, to: 'operations#add'
      post :substract, to: 'operations#substract'
    end

    resources :notes do
      collection do
        get :available_slots
      end

      member do
        patch :cancel
        patch :complete
      end
    end
  end
end
