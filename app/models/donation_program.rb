class DonationProgram < ApplicationRecord
  # Relationships
  # -----------------------------
  has_many :DonationHistories

  # Scopes
  # -----------------------------


  # Validations
  # -----------------------------
  validates :program, presence:true



  # Other methods
  # -------------

end
