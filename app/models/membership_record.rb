class MembershipRecord < ApplicationRecord
  # Relationships
  # -----------------------------
  has_many :ConstituentMembershipRecords


  # Scopes
  # -----------------------------


  # Validations
  # -----------------------------
  # validate start date on or before today
  # validate expiry date after start date
  # validate last renewed after start date and before end date 



  # Other methods
  # -------------

end
