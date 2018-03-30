class MembershipRecord < ApplicationRecord
  # Relationships
  # -----------------------------
  has_many :ConstituentMembershipRecords


  # Scopes
  # -----------------------------


  # Validations
  # -----------------------------
  # Validations
  # -----------------------------
  validates :membership_id, presence: true
  validates :membership_scheme, presence:true
  validates :membership_level, presence:true
  # no validations for add-ons as it is a feature the client will start to use in the future
  # validations on membership level type??
  validates :membership_status, presence:true
  validates_numericality_of :term, :only_integer => true, :greater_than=> 0
  # validate start date on or before today

  # validate expiry date after start date
  # validate last renewed after start date and before end date


  # Other methods
  # -------------

end
