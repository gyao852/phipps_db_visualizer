Rails.application.routes.draw do
  resources :donation_histories
  resources :constituents
  resources :addresses
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
