class Constituent < ApplicationRecord
  #relationships
  # has_many :addresses
  # has_many :donation_histories
  # has_many :constituent_events
  # has_many :contact_histories
  # has_many :constituent_membership_records


  #compulsory fields
  validates_presence_of:name
  validates_presence_of:last_group
  validates: phone_or_email
  validates:look_up_id





  private
  phone_or_email

  end


end
