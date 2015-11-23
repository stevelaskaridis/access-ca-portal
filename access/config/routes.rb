Rails.application.routes.draw do
  get '/:locale/:user_id/csr' => 'csr_gen#mozilla_csr'
  post '/:locale/:user_id/submit' => 'csr_gen#csr_submission'
  get '/:locale/error_csr_sub' => 'csr_gen#error_csr_sub'
  get '/:locale/find_csr' => 'csr_gen#find_csr'
  post '/:locale/find_csr' => 'csr_gen#csr_value'
  get '/:locale/find_csr/no_csr' => 'csr_gen#error'
  get '/:locale/ra/csr_list' => 'ra#csr_list'
  get '/:locale/ra/csr_pending' => 'ra#csr_pending'
  get '/:locale/ra/csr_approved' => 'ra#csr_approved'
  get '/:locale/ra/csr_rejected' => 'ra#csr_rejected'
  scope "(:locale)", locale: /#{APP_CONFIG['available_locales'].join('|')}/ do
    root 'people#index'
    get '/:locale' => 'people#index', as: 'verify_email'
    resources :people do
      get 'versions' => 'people_versions#index'
    end
    get '/people/confirm_email/:token' => 'people#verify_email'

    resources :organizations
    resources :hosts do
      get 'versions' => 'hosts_versions#index'
    end
    resources :certificate_requests, except: [:edit] do
      post 'approve' => 'certificate_requests#approve_csr', as: 'approve'
      post 'reject' => 'certificate_requests#reject_csr', as: 'reject'
    end
    get '/signup' => 'people#new', as: 'signup'
    get '/login' => 'sessions#new', as: 'login'
    post '/login' => 'sessions#create'
    get '/logout' => 'sessions#destroy', as: 'logout'
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
