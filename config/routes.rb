Rails.application.routes.draw do

    root to: "static_pages#home"    

    get 'execute_templates/create'

    get 'execute_templates/micro'

    get 'execute_templates/add_slide'
    get 'execute_templates/add_series'
    get 'execute_templates/associate_slide'

    get 'execute_templates/add_block_slide'
    get 'execute_templates/add_block_series'
    get 'execute_templates/associate_block_slide'

    get 'execute_templates/create_blocks'

    get 'execute_templates/block_fp1'
    get 'execute_templates/block_fok'
    get 'execute_templates/block_fm1'

    get 'execute_templates/review_block'
    get 'execute_templates/anotate_block'

    post 'list_blocks/add_block_slide'
    post 'list_blocks/add_block_series'
    post 'list_blocks/associate_block_slide'

    post 'list_blocks/block_fp1'
    post 'list_blocks/block_fok'
    post 'list_blocks/block_fm1'

    post 'list_blocks/review_block'
    post 'list_blocks/anotate_block'

    get 'inclusion_blocks/inclusion'

    post 'inclusion_blocks/block_fp1'
    post 'inclusion_blocks/inform_ok'
    post 'inclusion_blocks/block_fm1'

    post 'list_slides/color'
    post 'list_slides/tag'
    post 'list_slides/cover'

    get 'processing_slides/coloring_slides'
    get 'processing_slides/covering_slides'
    get 'processing_slides/tagging_slides'
    
    get 'static_pages/home'
    get 'static_pages/services'
    get 'static_pages/whoweare'
    get 'static_pages/customers'
    get 'static_pages/contact'
    get 'static_pages/help'
    get 'static_pages/faq'
    get 'static_pages/results'
    get 'static_pages/tech'
    get 'static_pages/portfolio'
    get 'static_pages/science'
    get 'static_pages/news'
    get 'static_pages/welcome_user'
    get 'static_pages/matriculate'

    get 'reports/index'
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

    resources :autos
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
    resources :obcodes
    resources :recipients

    get 'automatics/new_micro', to: 'automatics#new_micro'
    get 'automatics/new_macro', to: 'automatics#new_macro'
    resources :automatics
    resources :scripts
    resources :organs
    resources :results
    
    devise_for :users, path: 'users', controllers: { sessions: "users/sessions", registrations: "users/registrations", passwords: "users/passwords", unlocks: "users/unlocks", confirmations: "users/confirmations" }

    resources :users, only: [:index, :edit, :update, :show]


    devise_for :admins, path: 'admins', controllers: { sessions: "admins/sessions", passwords: "admins/passwords", unlocks: "admins/unlocks", confirmations: "admins/confirmations" }

    resources :admins, only: [:index]
    
    devise_for :patients, path: 'patients', controllers: { sessions: "patients/sessions" }

    get 'patients/fast_new_form'
    get 'patients/fast_new', to: 'patients#fast_new'
    
    resources :patients do
      resources :informs do
        resources :physicians
      end

      collection do
        get :last20
      end
    end

    resources :codevals do
      resources :factors
      resources :values
      collection {post :import}
    end

    resources :obcodes do
      collection {post :import}
    end

    resources :diagcodes do
      resources :autos
      collection {post :import}
    end
    
    resources :promoters do
      collection {post :import}
    end

    resources :branches do
      collection {post :import}
    end

    resources :organs do
      collection {post :import}
    end

    resources :entities do
      resources :branches
    end

    # get 'informs/preview/:id', to: 'informs#preview', as: 'preview'
    # get 'informs/descr_micro/:id', to: 'informs#descr_micro', as: 'descr_micro'
    get 'informs/distribution', to: 'informs#distribution', as: 'distribution'
    # get 'informs/descr_micros', to: 'informs#descr_micros', as: 'descr_micros'
    # get 'informs/set_revision', to: 'informs#set_revision', as: 'informs_set_revision'
    # get 'informs/index_revision', to: 'informs#index_revision', as: 'informs_index_revision'

    # get 'informs/set_ready', to: 'informs#set_ready', as: 'informs_set_ready'
    get 'informs/index_ready', to: 'informs#index_ready', as: 'informs_index_ready'


    resources :informs do
      resources :physicians
      resources :recipients
      resources :samples
      resources :studies
      resources :blocks
      resources :slides
      resources :macros
      resources :micros
      resources :diagnostics
      resources :cytologies
      
      resources :pictures, module: :informs

      collection do
        put :assign
        get :descr_micros
        get :index_revision
        get :last20
      end

      member do
        get :show_revision
        get :clear_revision
        get :descr_micro
        get :set_revision
        get :set_ready
        get :preview
      end
    end

    

    resources :recipients do
      resources :objections, module: :recipients
      resources :pictures, module: :recipients
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
      collection do
        put :color
      end
      collection do
        put :cover
      end
      collection do
        put :tag
      end
    end

    resources :macros do
      resources :objections, module: :macros
      resources :pictures, module: :macros
    end

    post 'micros/review', to: 'micros#review'
    post 'micros/anotate', to: 'micros#anotate'
    post 'micros/destroy_micro', to: 'micros#destroy_micro'

    resources :micros do
      resources :objections, module: :micros
      resources :pictures, module: :micros
    end

    post 'diagnostics/review', to: 'diagnostics#review'
    post 'diagnostics/anotate', to: 'diagnostics#anotate'
    post 'diagnostics/destroy_diagnostic', to: 'diagnostics#destroy_diagnostic'
    
    resources :diagnostics do
      resources :objections, module: :diagnostics
    end

    resources :physicians do
      resources :objections, module: :physicians
    end

    resources :automatics do
      resources :scripts
    end

    

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
