Rails.application.routes.draw do

  get 'objections/index'
  get 'objections/new'
  get 'objections/create'
  get 'objections/edit'
  get 'objections/update'
  get 'objections/delete'
  get 'objections/show'

  resources :samples do
    resources :objections, module: :samples
  end

  resources :physicians
  resources :diagnostics
  resources :micros
  resources :slides
  resources :blocks
  resources :macros
  
  resources :studies
  
  resources :informs do
    resources :physicians
    resources :samples
    resources :studies
    resources :macros
    resources :blocks
    resources :slides
    resources :micros
    resources :diagnostics
  end

  resources :patients do
    resources :informs do
      resources :physicians
    end
  end
  devise_scope :user do get "users" => "users#index"
  end

  root to: "users#index"

  resources :roles
  resources :values
  resources :factors
  resources :rates
  resources :costs

  resources :codevals
  resources :codevals do
  	resources :factors
    resources :values	
  end
  
  
  resources :entities do
    resources :branches
  end
  resources :branches, except: [:new]

  resources :promoters


	resources :admins, only: [:index]
	resources :users, only: [:index]

	devise_for :admins, path: 'admins', controllers: { sessions: "admins/sessions", passwords: "admins/passwords", unlocks: "admins/unlocks", confirmations: "admins/confirmations" }
	devise_for :users, path: 'users', controllers: { sessions: "users/sessions", registrations: "users/registrations", passwords: "users/passwords", unlocks: "users/unlocks", confirmations: "users/confirmations" }
	


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
