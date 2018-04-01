class Constituent < ApplicationRecord
  # Relationships
  # -----------------------------
  has_many :addresses
  has_many :donation_histories
  has_many :donation_programs, through: :donation_histories
  has_many :constituent_events
  has_many :events, through: :constituent_events
  has_many :contact_histories
  has_many :constituent_membership_records
  has_many :membership_records, through: :constituent_membership_records
  # Scopes
  # -----------------------------
    scope :alphabetical, -> { order('name') }
    scope :by_lookup_id, -> {order(:lookup_id)}
    scope :alphabetical_last_group, -> {order(:last_group)}
    scope :alphabetical_name, -> {order(:name)}

  #
  # Validations
  # -----------------------------
  validates :lookup_id, presence: true
  # no validations for suffix
  # no validations for title
  # check
  validates :name, format: { with: /\A[A-Z]\w+\-?\w+?\z/ , message: "Name field cannot contain special characters"}, presence: true
  # check
  validates :last_group, presence: true , format: { with: /\A[A-Z]\w+\-?\w+?\z/ , message: "Last_group field cannot contain special characters"}
  validates :phone, format: { with: /\A\(([0-9]{3})\)[-]([0-9]{3})[-]([0-9]{4})\z/ , message: "format of phone number is incorrect"}
  validates :email_id, format: { with:/\A[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}\z/, message: "format of email address is incorrect"}
  validates_date :dob, before: Date.today
  # validates :do_not_email, presence: true

  # Other methods
  # -------------
  def current_address
    # map all addresses that belong to the constituent
  end

  def current_membership
    #
  end

  private
  # address_or_email
  #   return true
  # end
end
