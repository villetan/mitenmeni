Rails.application.routes.draw do


  resources :friendships
  get 'accept_request', to: 'friendships#accept_request'
  get 'delete_friendship', to: 'friendships#delete_friendship'

  get 'amenities/index'

  get 'amenities/show'

  get 'amenities/new'

  get 'amenities/edit'

  get 'amenities/index'

  get 'amenities/show'

  get 'amenities/new'

  get 'amenities/edit'

  resource :session, only: [:new, :create, :destroy]

  get 'signin', to: 'sessions#new'
  #delete does not work dunno why
  delete 'signout', to: 'sessions#destroy'

  get 'signup', to: 'users#new'

  post 'lock_account', to: 'users#lock_account'

  resources :ratings, :only => [:index, :new, :show, :create, :destroy, :edit, :update]
  resources :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'frontpage#index'


  #Special routes
  get 'amenities', to: 'amenities#index'

  get 'places', to: 'places#index'
  post 'places', to:'places#search'
  get 'places/:id', to:'places#show'
  get 'redirect_from_ratings', to: 'ratings#redirect_from_ratings'

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
