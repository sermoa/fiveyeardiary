Fiveyeardiary::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  match "/auth/:provider/callback" => "sessions#create"
  match "/auth/failure" => "sessions#failure"
  match '/stats' => 'pages#stats'

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  match '/signup' => 'identities#new', as: :sign_up
  match '/signin' => 'sessions#new', as: :sign_in
  match '/signout' => 'sessions#destroy', as: :sign_out

  match "/diary/day/:day" => 'notes#day_of_month', as: :day_of_month_diary
  match "/diary/:year/week/:week_number" => 'notes#week', as: :week_diary
  match "/diary/:month/:day" => 'notes#day', as: :daily_diary
  match "/diary/:weekday" => 'notes#week_day', as: :week_day_diary

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  resources :notes, only: [:new, :create, :edit, :update]
  resource  :profile, only: [:edit, :update]
  resource  :settings, only: [:edit, :update]

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

  root :to => 'pages#home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
