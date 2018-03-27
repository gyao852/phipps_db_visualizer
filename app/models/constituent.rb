class Constituent < ApplicationRecord
  # Relationships
  # -----------------------------
  has_many :addresses
  has_many :donation_histories
  # has_many :constituent_events
  # has_many :contact_histories
  # has_many :constituent_membership_records

  # Scopes
  # -----------------------------


  # Validations
  # -----------------------------
  #compulsory fields
  validates :name, presence: true, format: { with: , message: "Name field cannot contain special characters"}
  validates :last_group, presence: true, format: { with: , message: "Last_group field cannot contain special characters"}
  validate_presence_of :lookup_id
  validates :phone, format: { with:^\(([0-9]{3})\)[-]([0-9]{3})[-]([0-9]{4})$ , message: "format of phone number is incorrect"}
  validate :email_id, format: { with:^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}[\w-]{2,4}?$ , message: "format of email address is incorrect"}
  validates_date :dob
  # validates :address_or_email

  # Other methods
  # -------------



  private
  # address_or_email
  #   return true
  # end
end
