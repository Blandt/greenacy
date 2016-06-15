Greenacy::Application.routes.draw do


  resources :activity_logs
  root :to => 'users#index', :as => :users_index
  get "users/manage" => "users#manage"
  get "companies/market" => "companies#market"
  get "users/change/:id" => "users#change", :as => :users_change
  get "users/changepwd/:id" => "users#changepwd", :as => :users_changepwd
  get "users/adduser" => "users#adduser", :as => :users_adduser
  post "users/submituser" => "users#submituser", :as => :users_submituser
  patch "users/changeupdate/:id" => "users#changeupdate", :as => :users_changeupdate
  patch "users/changeupdatepwd/:id" => "users#changeupdatepwd", :as => :users_changeupdatepwd
  get "users/userdelete/:id" => "users#userdelete", :as => :users_userdelete
  patch "companies/setmarket/:id" => "companies#setmarket", :as => :companies_setmarket
  post "companies/checkCompany" => "companies#checkCompany"
  post "orders/startOrderExistCompany" => "orders#startOrderExistCompany"
  post "companies/startOrderNewCompany" => "companies#startOrderNewCompany"
  post "order_details/addToCart" => "order_details#addToCart"
  get "orders/orderdelete/:id" => "orders#orderdelete", :as => :orders_orderdelete
  get "order_details/view/:id" => "order_details#view", :as => :order_details_view
  get "orders/team/:id" => "orders#team", :as => :orders_team
  post "order_details/orderdetailsdelete" => "order_details#orderdetailsdelete", :as => :order_details_delete
  get "orders/orderclose/:id" => "orders#orderclose", :as => :order_orderclose
  get "products/view/:id" => "products#view", :as => :products_view
  get "orders/archive" => "orders#archive", :as => :order_archive
  get "orders/archivelist/:id" => "orders#archivelist", :as => :orders_archivelist
  get "orders/myarchivelist" => "orders#myarchivelist", :as => :order_myarchivelist
  post "products/add_activity" => "products#add_activity"
  get "activity_logs/list/:id" => "activity_logs#list", :as => :activity_logs_list
  get "order_details/edit/:id" => "order_details#edit", :as => :order_details_edit
  post "order_details/updateCart" => "order_details#updateCart"
  get "orders/archiveeach/:id" => "orders#archiveeach", :as => :order_archiveeach
  get "orders/startorder/:id" => "orders#startorder", :as => :order_startorder
  get "products/addtoorder/:id" => "products#addtoorder", :as => :products_addtoorder
  get "categories/manage" => "categories#manage", :as => :categories_manage
  get "categories/change/:id" => "categories#change", :as => :categories_change
  post "categories/changeupdate" => "categories#changeupdate", :as => :categories_changeupdate
  get "categories/addnew" => "categories#addnew", :as => :categories_addnew
  post "categories/addCat" => "categories#addCat", :as => :categories_addCat

  devise_for :admins, :skip => [:registrations]
  devise_for :users, controllers: {sessions: 'users/sessions', registrations: 'registrations'}

  resources :users
  resources :companies
  resources :products, only: [:show, :index]
  resources :categories, only: [:show, :index]
  resources :roles, only: [:show, :index]
  resources :orders
  resources :order_details


    #'devise/sessions#create', :as => 'login'
    #get 'admin' => 'admin/users#index' , :as => :admin
    resource :control_panel, only: [:index, :new, :create, :destroy]

    #resources :users, only: [:show, :index]
    resources :posts, only: [:show, :index]
    #resources :categories, only: [:show, :index]
    #resources :products, only: [:show, :index]
    default_url_options :host => "http://45.33.75.125"
    get 'about-us', to: 'posts/1'

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
  namespace :admin do
    get '', to:'users#index', as: '/'
    resources :posts
    resources :categories
    resources :companies
    resources :users
    post "users/getManager" => "users#getManager"
    resources :products
    resources :roles
    #resources :uploads, only: [:index, :show, :update, :create]
    #resources :settings, only: [:index, :edit, :update]
    #mount Idioma::Engine => "/idioma"
  end
end
