Rails.application.routes.draw do
  resources :flight, only: [:index, :show]
  resources :hotel, only: [:index, :show]

end
