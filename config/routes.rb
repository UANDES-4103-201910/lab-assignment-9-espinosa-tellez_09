Rails.application.routes.draw do
  resources :user_tickets
  resources :tickets
  resources :places
  resources :events
  devise_for :users, controllers: { omniauth_callbacks: 'callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users

  root :to => 'sessions#new'

  post '/login',   to: 'sessions#create', as: :log_in
  delete '/log_out' => 'sessions#destroy', as: :log_out

  get '/sign_in' => 'registrations#new', as: :registrations
  post '/sign_in' => 'registrations#create', as: :sign_in

  get '/check_out' => 'user_tickets#update_all', as: :update_all_ut
  get '/receipt' => 'user_tickets#receipt', as: :receipt
  get '/confirm' => 'user_tickets#update_all_confirm', as: :confirm


end
