Rails.application.routes.draw do

	root to: "admins#index"

	resources :users
	resources :admins

	devise_for :admins, path: 'admins', controllers: { sessions: "admins/sessions", registrations: "admins/registrations", passwords: "admins/passwords", unlocks: "admins/unlocks", confirmations: "admins/confirmations" }

	devise_for :users, path: 'users', controllers: { sessions: "users/sessions", registrations: "users/registrations", passwords: "users/passwords", unlocks: "users/unlocks", confirmations: "users/confirmations" }
	


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
