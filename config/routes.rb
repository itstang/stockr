Rails.application.routes.draw do
  get 'sessions/new'

  root                'static_pages#home'
  get    'help'    => 'static_pages#help'
  get    'about'   => 'static_pages#about'
  get    'dashboard' => 'static_pages#dashboard'
  get    'stocks'  => 'static_pages#stocks'
  get    'stocks/add' => 'static_pages#stocks_add'
  # get    'stocks/media' => 'static_pages#scrape_media'
  get    'stocks/:id' => 'static_pages#stocks_show'
  get    'rankings' => 'static_pages#rankings'
  get    'history' => 'static_pages#history'
  get    'contact' => 'static_pages#contact'
  get    'search'  => 'static_pages#search'
  get    'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  post   'stocks/buy' => 'static_pages#stocks_buy'
  post   'stocks/sell' => 'static_pages#stocks_sell'
  delete 'logout'  => 'sessions#destroy'
  resources :users
  resources :stocks
end
