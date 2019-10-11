Rails.application.routes.draw do

	root to: "admins#index"

	resources :users
	resources :admins

	devise_for :users, path: 'users'
	devise_for :admins, path: 'admins'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
