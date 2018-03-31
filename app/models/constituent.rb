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
  # validates :name, presence: true, format: { with:/\A\w+\-\w+\z/i , message: "Name field cannot contain special characters"}
  # check
  # validates :last_group, presence: true , format: { with:/\A\w+\-\w+\z/i , message: "Last_group field cannot contain special characters"}

  # validates :phone, format: { with: /\A\(([0-9]{3})\)[-]([0-9]{3})[-]([0-9]{4})\z/i , message: "format of phone number is incorrect"}
  # validates :email_id, format: { with:/\A[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}[\w\-]{2,4}?\z/i , message: "format of email address is incorrect"}
  # validates_date :dob, before: lambda{Date.today}
  # validates :do_not_email, presence: true


  # Scopes
  scope :by_lookup_id, -> {order(:lookup_id)}
  scope :alphabetical_last_group, -> {order(:last_group)}
  scope :alphabetical_name, -> {order(:name)}


  # Other methods
  # -------------
  def current_address
  end

  def current_membership
  end

  private
  # address_or_email
  #   return true
  # end

  # Custom validations
end
