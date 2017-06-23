Rails.application.routes.draw do
  devise_for :users
  resources :commercials, except: :index
  post 'commercials/:id/like', to: 'commercials#like'
  post 'commercials/:id/dislike', to: 'commercials#dislike'
  get 'search', to: 'commercials#search'
  get 'my', to: 'commercials#my'
  get 'commercials', to: 'commercials#index'

  root 'home#home'

  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
