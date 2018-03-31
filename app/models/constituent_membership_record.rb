class ConstituentMembershipRecord < ApplicationRecord
  # Relationships
  # -----------------------------
  belongs_to :Constituent
  belongs_to :MembershipRecord


  # Scopes
  # -----------------------------


  # Validations
  # -----------------------------
  validates :lookup_id, presence:true
  validates :membership_id, presence:true



  # Other methods
  # -------------

end
