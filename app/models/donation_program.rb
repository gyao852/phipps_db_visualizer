class DonationProgram < ApplicationRecord
  # Relationships
  # -----------------------------
  has_many :DonationHistories

  # Scopes
  # -----------------------------
    scope :alphabetical, -> { order('program') }


  # Validations
  # -----------------------------
  validates :program, presence:true



  # Other methods
  # -------------

end
