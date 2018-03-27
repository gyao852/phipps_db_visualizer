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
  validates :name, presence: true #, format: { with: , message: "Name field cannot contain special characters"}
  validates :last_group, presence: true #, format: { with: , message: "Last_group field cannot contain special characters"}
  validates_presence_of :lookup_id
  validates :phone, format: { with: /\A\(([0-9]{3})\)[-]([0-9]{3})[-]([0-9]{4})\z/i , message: "format of phone number is incorrect"}
  validates :email_id, format: { with:/\A[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}[\w\-]{2,4}?\z/i , message: "format of email address is incorrect"}
  validates_date :dob
  # validates :address_or_email

  # Other methods
  # -------------



  private
  # address_or_email
  #   return true
  # end
end
