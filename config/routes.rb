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

  resources :unclean_constituents do
    # collection {post :import}
    collection {post :importfile}
  end

  resources :unclean_addresses do
    # collection {post :import}
    collection {post :importfile}
  end

  resources :unclean_membership_records do
    # collection {post :import}
    collection {post :importfile}
  end

  resources :unclean_constituent_membership_records do
    # collection {post :import}
    collection {post :importfile}
  end

  resources :unclean_contact_histories do
    # collection {post :import}
    collection {post :importfile}
  end

  resources :unclean_constituent_events do
    # collection {post :import}
    collection {post :importfile}
  end

  resources :unclean_events do
    # collection {post :import}
    collection {post :importfile}
  end

  resources :unclean_donation_histories do
    # collection {post :import}
    collection {post :importfile}
  end

  resources :unclean_donation_programs do
    # collection {post :import}
    collection {post :importfile}
  end

  resources :sessions

  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'import_page' => 'imports#import_page', as: :import_page
  get 'imports_importdata' => 'imports#importdata', :as => :importdata
  get 'reports' => 'home#reports', as: :reports


  get 'constituent_individuals' => 'constituents#index_individuals', as: :index_individuals
  get 'constituent_households' => 'constituents#index_households', as: :index_households
  get 'constituent_organizations' => 'constituents#index_organizations', as: :index_organizations

  get 'unclean_individuals' => 'unclean_constituents#unclean_individuals', as: :index_unclean_individuals
  get 'unclean_households' => 'unclean_constituents#unclean_households', as: :index_unclean_households
  get 'unclean_organizations' => 'unclean_constituents#unclean_organizations', as: :index_unclean_organizations

  get 'duplicate_constituents' => 'unclean_constituents#duplicate_constituents', as: :index_duplicate_constituents
  get 'duplicate_individuals' => 'unclean_constituents#duplicate_individuals', as: :index_duplicate_individuals
  get 'duplicate_organizations' => 'unclean_constituents#duplicate_organizations', as: :index_duplicate_organizations
  get 'duplicate_households' => 'unclean_constituents#duplicate_households', as: :index_duplicate_households


  get 'invalid_constituents' => 'unclean_constituents#invalid_constituents', as: :index_invalid_constituents
  get 'invalid_individuals' => 'unclean_constituents#invalid_individuals', as: :index_invalid_individuals
  get 'invalid_households' => 'unclean_constituents#invalid_households', as: :index_invalid_households
  get 'invalid_organizations' => 'unclean_constituents#invalid_organizations', as: :index_invalid_organizations


  # Use case reports
  get 'generate_donation_report' => 'home#generate_donation_report', as: :generate_donation_report
  get 'generate_contact_history_report' => 'home#generate_contact_history_report', as: :generate_contact_history_report
  get 'generate_attendance_report' => 'home#generate_attendance_report', as: :generate_attendance_report

  # Bad constituents reports
  get 'generate_invalid_constituents_report' => 'home#generate_invalid_constituents_report', as: :generate_invalid_constituents_report
  get 'generate_invalid_phone_constituents_report' => 'home#generate_invalid_phone_constituents_report', as: :generate_invalid_phone_constituents_report
  get 'generate_invalid_email_constituents_report' => 'home#generate_invalid_email_constituents_report', as: :generate_invalid_email_constituents_report
  get 'generate_incomplete_name_constituents_report' => 'home#generate_incomplete_name_constituents_report', as: :generate_incomplete_name_constituents_report
  get 'generate_no_contact_constituents_report' => 'home#generate_no_contact_constituents_report', as: :generate_no_contact_constituents_report
  get 'generate_duplicate_constituents_report' => 'home#generate_duplicate_constituents_report', as: :generate_duplicate_constituents_report


  #Bad address reports
  get 'generate_invalid_zips_addresses_report' => 'home#generate_invalid_zips_addresses_report', as: :generate_invalid_zips_addresses_report
  get 'generate_invalid_addresses_1_report' => 'home#generate_invalid_addresses_1_report', as: :generate_invalid_addresses_1_report
  get 'generate_invalid_state_addresses_report' => 'home#generate_invalid_state_addresses_report', as: :generate_invalid_state_addresses_report
  get 'generate_invalid_city_addresses_report' => 'home#generate_invalid_city_addresses_report', as: :generate_invalid_city_addresses_report
  get 'generate_invalid_country_addresses_report' => 'home#generate_invalid_country_addresses_report', as: :generate_invalid_country_addresses_report

  #
  # get 'goals_import_page' => 'goals#goals_import_page', as: :goals_import_page
  # get 'constituents_import_page' => 'constituents#constituents_import_page', as: :constituents_import_page
  # get 'unclean_constituents_import_page' => 'unclean_constituents#unclean_import_page', as: :unclean_import_page
  # get 'address_import_page' => 'addresses#addresses_import_page', as: :address_import_page
  # get 'membership_record_import_page' => 'membership_records#membership_record_import_page', as: :membership_record_import_page
  # get 'constituent_membership_record_import_page' => 'constituent_membership_records#constituent_membership_record_import_page', as: :constituent_membership_record_import_page
  # get 'donation_histories_import_page' => 'donation_histories#donation_histories_import_page', as: :donation_histories_import_page
  # get 'donation_programs_import_page' => 'donation_programs#donation_programs_import_page', as: :donation_programs_import_page
  # get 'events_import_page' => 'events#events_import_page', as: :events_import_page
  # get 'constituents_events_import_page' => 'constituent_events#constituents_events_import_page', as: :constituents_events_import_page
  # get 'contact_histories_import_page' => 'contact_histories#contact_history_import_page', as: :contact_histories_import_page
  # Routes for duplicate record filtering pages
  get 'invalid_emails' => 'unclean_constituents#index_invalid_emails', as: :invalid_emails
  get 'invalid_phones' => 'unclean_constituents#index_invalid_phones', as: :invalid_phones
  get 'invalid_zips' => 'unclean_constituents#_invalid_zips', as: :invalid_zips

  get 'duplicates_unresolved' => 'duplicates#unresolved', as: :duplicates_unresolved
  get 'duplicates_deleted' => 'duplicates#deleted', as: :duplicates_deleted
  get 'duplicates_merged' => 'duplicates#merged', as: :duplicates_merged
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  get 'search_constituents' => 'constituents#search', as: :search_constituents
  post 'search' => 'application#search', as: :search_all

  # Set the root url
  root :to => 'home#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
