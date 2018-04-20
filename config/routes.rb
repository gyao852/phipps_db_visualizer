Rails.application.routes.draw do
  
  resources :goals
  resources :imports do
    collection do 
      post 'importfile'
      post 'importdata'
    end
    
  end
  resources :addresses do
    collection {post :importfile}
  end
  resources :goals do
    collection {post :importfile}
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
    # collection {post :import}
    collection {post :importfile}
  end

  resources :unclean_constituent do
    # collection {post :import}
    collection {post :importfile}
  end

  resources :unclean_address do
    # collection {post :import}
    collection {post :importfile}
  end

  resources :unclean_membership_record do
    # collection {post :import}
    collection {post :importfile}
  end

  resources :unclean_constituent_membership_record do
    # collection {post :import}
    collection {post :importfile}
  end

  resources :unclean_contact_history do
    # collection {post :import}
    collection {post :importfile}
  end

  resources :unclean_constituent_event do
    # collection {post :import}
    collection {post :importfile}
  end

  resources :unclean_event do
    # collection {post :import}
    collection {post :importfile}
  end

  resources :unclean_donation_history do
    # collection {post :import}
    collection {post :importfile}
  end

  resources :unclean_donation_program do
    # collection {post :import}
    collection {post :importfile}
  end

  resources :sessions

  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'import_page' => 'imports#import_page', as: :import_page
  get 'imports_importdata' => 'imports#importdata', :as => :importdata
  get 'reports' => 'home#reports', as: :reports
  get 'generate_donation_report' => 'home#generate_donation_report', as: :generate_donation_report
  get 'generate_contact_history_report' => 'home#generate_contact_history_report', as: :generate_contact_history_report
  get 'goals_import_page' => 'goals#goals_import_page', as: :goals_import_page
  get 'constituents_import_page' => 'constituents#constituents_import_page', as: :constituents_import_page
  get 'unclean_constituents_import_page' => 'unclean_constituents#unclean_import_page', as: :unclean_import_page
  get 'address_import_page' => 'addresses#addresses_import_page', as: :address_import_page
  get 'membership_record_import_page' => 'membership_records#membership_record_import_page', as: :membership_record_import_page
  get 'constituent_membership_record_import_page' => 'constituent_membership_records#constituent_membership_record_import_page', as: :constituent_membership_record_import_page
  get 'donation_histories_import_page' => 'donation_histories#donation_histories_import_page', as: :donation_histories_import_page
  get 'donation_programs_import_page' => 'donation_programs#donation_programs_import_page', as: :donation_programs_import_page
  get 'events_import_page' => 'events#events_import_page', as: :events_import_page
  get 'constituents_events_import_page' => 'constituent_events#constituents_events_import_page', as: :constituents_events_import_page
  get 'contact_histories_import_page' => 'contact_histories#contact_history_import_page', as: :contact_histories_import_page
  # Routes for duplicate record filtering pages
  get 'duplicates_unresolved' => 'duplicates#unresolved', as: :duplicates_unresolved
  get 'duplicates_deleted' => 'duplicates#deleted', as: :duplicates_deleted
  get 'duplicates_merged' => 'duplicates#merged', as: :duplicates_merged
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  # Set the root url
  root :to => 'home#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
