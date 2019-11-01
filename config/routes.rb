Rails.application.routes.draw do

  resources :obcodes
  resources :autos
  resources :diagcodes
  get 'reports/status'
  get 'reports/objections'
  get 'reports/sales'
  get 'reports/reports_params_today'
  get 'reports/reports_params_yes'
  get 'reports/reports_params_yes2'
  get 'reports/reports_params_week'

  get 'pictures/index'
  get 'pictures/new'
  get 'pictures/create'
  get 'pictures/edit'
  get 'pictures/update'
  get 'pictures/delete'
  get 'pictures/show'


  get 'objections/index'
  get 'objections/new'
  get 'objections/create'
  get 'objections/edit'
  get 'objections/update'
  get 'objections/delete'
  get 'objections/show'

    root to: "users#index"

    resources :roles
    resources :values
    resources :factors
    resources :rates
    resources :costs
    resources :codevals
    resources :branches, except: [:new]
    resources :promoters
    resources :physicians
    resources :pictures

    resources :admins, only: [:index]
    resources :users, only: [:index]
    devise_for :admins, path: 'admins', controllers: { sessions: "admins/sessions", passwords: "admins/passwords", unlocks: "admins/unlocks", confirmations: "admins/confirmations" }
    devise_for :users, path: 'users', controllers: { sessions: "users/sessions", registrations: "users/registrations", passwords: "users/passwords", unlocks: "users/unlocks", confirmations: "users/confirmations" }

    devise_scope :user do get "users" => "users#index"
    end


    resources :codevals do
      resources :factors
      resources :values
      collection {post :import}
    end
    
    resources :entities do
      resources :branches
    end

    resources :informs do
      resources :physicians
      resources :samples
      resources :studies
      resources :macros
      resources :blocks
      resources :slides
      resources :micros
      resources :diagnostics
      resources :pictures, module: :informs
    end

    resources :samples do
      resources :objections, module: :samples
      resources :pictures, module: :samples
    end

    resources :studies do
      resources :objections, module: :studies
    end

    resources :blocks do
      resources :objections, module: :blocks
    end

    resources :slides do
      resources :objections, module: :slides
    end

    resources :macros do
      resources :objections, module: :macros
      resources :pictures, module: :macros
    end

    resources :micros do
      resources :objections, module: :micros
      resources :pictures, module: :micros
    end

    resources :diagnostics do
      resources :objections, module: :diagnostics
    end

    resources :physicians do
      resources :objections, module: :physicians
    end



    resources :patients do
      resources :informs do
        resources :physicians
      end
    end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
