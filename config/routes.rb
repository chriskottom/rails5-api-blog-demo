Rails.application.routes.draw do
  post 'sessions' => 'sessions#create', as: 'sign_in'
  delete 'sessions/:id' => 'sessions#destroy', as: 'sign_out'

  resources :posts
  resources :users
end
