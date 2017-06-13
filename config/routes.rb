Rails.application.routes.draw do
  resources :commercials
  post 'commercials/:id/like', to: 'commercials#like'
  post 'commercials/:id/dislike', to: 'commercials#dislike'
  get 'search', to: 'commercials#search'

  get 'signup', to: 'users#new'
  resources :users, except: [:new]

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  root 'users#new'

  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
