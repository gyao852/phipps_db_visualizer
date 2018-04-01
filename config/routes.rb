Rails.application.routes.draw do
  resources :addresses
  resources :users
  resources :events
  resources :constituent_events
  resources :donation_programs
  resources :contact_histories
  resources :membership_records
  resources :constituent_membership_records
  resources :donation_histories
  resources :constituents do
    collection {post :import}
  end

  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'import_page' => 'constituents#import_page', as: :import_page

  # Routes for duplicate record filtering pages
  get 'duplicates_unresolved' => 'duplicates#unresolved', as: :duplicates_unresolved
  get 'duplicates_deleted' => 'duplicates#deleted', as: :duplicates_deleted
  get 'duplicates_merged' => 'duplicates#merged', as: :duplicates_merged

  # Set the root url
  root :to => 'home#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
