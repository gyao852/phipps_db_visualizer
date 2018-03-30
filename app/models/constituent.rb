class Constituent < ApplicationRecord
  # Relationships
  # -----------------------------
  has_many :Addresses
  has_many :DonationHistories
  has_many :ConstituentEvents
  has_many :ContactHistories
  has_many :ConstituentMembershipRecords

  # Scopes
  # -----------------------------
    scope :alphabetical, -> { order('name') }

  #
  # Validations
  # -----------------------------
  validates :lookup_id, presence: true
  # no validations for suffix
  # no validations for title
  # check
  validates :name, presence: true , format: { with:/\A\w+\-\w+\z/i , message: "Name field cannot contain special characters"}
  # check
  validates :last_group, presence: true , format: { with:/\A\w+\-\w+\z/i , message: "Last_group field cannot contain special characters"}

  validates :phone, format: { with: /\A\(([0-9]{3})\)[-]([0-9]{3})[-]([0-9]{4})\z/i , message: "format of phone number is incorrect"}
  validates :email_id, format: { with:/\A[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}[\w\-]{2,4}?\z/i , message: "format of email address is incorrect"}
  validates_date :dob, before: lambda{Today.date}
  validates :do_not_email, presence: true

  # Other methods
  # -------------



  private
  # address_or_email
  #   return true
  # end
end
