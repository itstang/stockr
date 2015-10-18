Rails.application.routes.draw do
  get 'sessions/new'

  root                'static_pages#home'
  get    'help'    => 'static_pages#help'
  get    'about'   => 'static_pages#about'
  get    'dashboard' => 'static_pages#dashboard'
  get    'stocks'  => 'static_pages#stocks'
  get    'rankings' => 'static_pages#rankings'
  get    'history' => 'static_pages#history'
  get    'contact' => 'static_pages#contact'
  get    'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  resources :users
end
