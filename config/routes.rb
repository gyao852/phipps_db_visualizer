Rails.application.routes.draw do
  resources :addresses do
    collection {post :import}
  end
  resources :users
  resources :events do
    collection {post :import}
  end
  resources :constituent_events do
    collection {post :import}
  end
  resources :donation_programs do
    collection {post :import}
  end
  resources :contact_histories do
    collection {post :import}
  end
  resources :membership_records do
    collection {post :import}
  end
  resources :constituent_membership_records do
    collection {post :import}
  end
  resources :donation_histories do
    collection {post :import}
  end
  resources :constituents do
    collection {post :import}
  end

  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'import_page' => 'constituents#import_page', as: :import_page
  get 'address_import_page' => 'addresses#addresses_import_page', as: :address_import_page

  # Routes for duplicate record filtering pages
  get 'duplicates_unresolved' => 'duplicates#unresolved', as: :duplicates_unresolved
  get 'duplicates_deleted' => 'duplicates#deleted', as: :duplicates_deleted
  get 'duplicates_merged' => 'duplicates#merged', as: :duplicates_merged

  # Set the root url
  root :to => 'home#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
