Rails.application.routes.draw do

  get 'comments/index'
  resources :invoices
  resources :municipalities do
    collection do
      post :import
    end
  end
  resources :oldcitos do
    collection do
      post :import
      get :trouble_index
    end
  end
  
  get 'imports/oldrecord_import_index'
  get 'imports/oldcito_import_index'
  get 'imports/import_date_filter'
  get 'imports/oldrecord_import_patient'
  get 'imports/oldcito_import_patient'

  resources :oldrecords do
    collection do
      post :import
      get :trouble_index
    end
  end
  
  post 'suggestions/review', to: 'suggestions#review'
  post 'suggestions/anotate', to: 'suggestions#anotate'
  resources :suggestions
  resources :citocodes do
    collection {post :import}
  end
    root to: "static_pages#home"    

    get 'execute_templates/create'

    get 'execute_templates/micro'
    get 'execute_templates/micro_new'

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

    # get 'inclusion_blocks/block_fp1'
    # get 'inclusion_blocks/inform_ok'
    # get 'inclusion_blocks/block_fm1'

    resources :inclusion_blocks do
      member do
        get :block_fp1
        get :block_fm1
        get :inform_ok
      end
    end
    post 'inclusion_blocks/massive_inclusion'
    post 'inclusion_blocks/block_store'

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
    
    get 'reports/sales2'
    post 'reports/invoice'
    get 'reports/reports_params_today'
    get 'reports/reports_params_yes'
    get 'reports/reports_params_yes2'
    get 'reports/reports_params_week'

    resources :reports do
      collection do
        get :billings
        get :sales
      end

      member do
        post :invoice
        get :show_sale
        get :show_billing
        get :show_branch
        get :show_rips
        get :show_rips_ap
        get :show_rips_us
        get :show_rips_af
        get :show_rips_ad
        get :show_rips_ct
        get :show_affinity
      end
    end

    resources :objections

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
    get 'automatics/new_cito', to: 'automatics#new_cito'
    get 'automatics/index_macro', to: 'automatics#index_macro'
    get 'automatics/index_micro', to: 'automatics#index_micro'
    get 'automatics/index_cito', to: 'automatics#index_cito'

    resources :automatics
    resources :scripts
    resources :organs
    resources :results do
      member do
        get :show_oldrecord
      end
    end
    resources :cytologies

    resources :cytologies do
      member do
        get :review
        get :anotate
      end
    end
    
    devise_for :users, path: 'users', controllers: { sessions: "users/sessions", registrations: "users/registrations", passwords: "users/passwords", unlocks: "users/unlocks", confirmations: "users/confirmations" }

    resources :users, only: [:index, :edit, :update, :show]


    devise_for :admins, path: 'admins', controllers: { sessions: "admins/sessions", passwords: "admins/passwords", unlocks: "admins/unlocks", confirmations: "admins/confirmations" }

    resources :admins, only: [:index]
    
    devise_for :patients, path: 'patients', controllers: { sessions: "patients/sessions" }

    get 'patients/fast_new_form'
    get 'patients/fast_new', to: 'patients#fast_new'
    get 'patients/new_series', to: 'patients#new_series'
    post 'patients/create_series', to: 'patients#create_series'
    
    get 'patients/new_single', to: 'patients#new_single'
    post 'patients/create_new', to: 'patients#create_new'
    resources :patients do
      resources :informs do
        resources :physicians
      end

      member do
        post :matriculate
      end

      collection do
        get :index_one
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

    
    get 'informs/distribution', to: 'informs#distribution', as: 'distribution'
    get 'informs/distribution_cyto', to: 'informs#distribution_cyto', as: 'distribution_cyto'
    get 'informs/index_ready', to: 'informs#index_ready', as: 'informs_index_ready'
    get 'informs/index_published', to: 'informs#index_published', as: 'informs_index_published'
    get 'informs/index_downloaded', to: 'informs#index_downloaded', as: 'informs_index_downloaded'


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
      resources :suggestions
      
      resources :pictures, module: :informs

      collection do
        put :assign
        put :assign_cyto
        get :descr_micros
        get :descr_micros_cyto
        get :index_revision
        get :last20
        get :index_oldrecords
        get :index_oldcitos

        put :publish
        put :unpublish
        put :undownload
        get :export_foxpro
        get :view_export_foxpro
      end

      member do
        get :show_revision
        get :clear_revision
        get :descr_micro
        get :set_revision
        put :set_revision_secretary
        get :set_ready
        get :preview
        get :autos_micro
        get :anulate
        put :switch_patient
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
      collection do
        put :massive_inclusion
      end
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
