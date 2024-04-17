Rails.application.routes.draw do
  # Static Pages
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get 'provinces/:id/tax_rates', to: 'provinces#tax_rates', as: 'fetch_tax_rates'
  # Product Routes
  get 'products/:id', to: 'home#show', as: :product
  resources :products, only: [:index, :show]
  
  get 'on_sale', to: 'home#on_sale'
  get 'new_products', to: 'home#new_products'
  # Cart Routes
  post 'add_to_cart/:id', to: 'home#add_to_cart', as: :add_to_cart
  patch 'update_cart_item/:id', to: 'home#update_cart_item', as: :update_cart_item
  delete 'remove_from_cart/:id', to: 'home#remove_from_cart', as: :remove_from_cart
  get 'home/cart', to: 'home#cart', as: 'cart'

  # Orders Routes
  resources :orders, only: [:new, :create, :show]
  get 'orders', to: 'orders#index'
  get 'orders/:id/confirm_payment', to: 'orders#confirm_payment', as: 'confirm_payment_order'
  resources :orders do
    member do
      get 'confirm_payment'
    end
  end

  # Devise Routes for Users and Admins
  devise_for :admins
  devise_for :users, controllers: { registrations: 'users/registrations' }
  get 'profile', to: 'users#show'
  resources :users, only: [:show, :update]
  # Admin Namespace
  namespace :admin do
    get 'dashboard/index'
    resources :orders
    devise_for :admins, skip: :registrations
    root to: "products#index"
    resources :products
    resources :categories
    resources :provinces, only: [:index, :edit, :update]
  end

  # Category Routes
  resources :categories, only: [:index, :show]
  

  
  # Home/Index Route
  root 'home#index'
  get 'home/index', to: 'home#index', as: 'home_index'
end
