class Constituent < ApplicationRecord
  # Relationships
  # -----------------------------
  # has_many :addresses
  has_many :donation_histories
  # has_many :constituent_events
  # has_many :contact_histories
  # has_many :constituent_membership_records

  # Scopes
  # -----------------------------


  # Validations
  # -----------------------------
  #compulsory fields
  validates_presence_of :name
  validates_presence_of :last_group
  validates_presence_of :look_up_id
  # validates :address_or_email

  # Other methods
  # -------------



  private
  # address_or_email
  #   return true
  # end

end
