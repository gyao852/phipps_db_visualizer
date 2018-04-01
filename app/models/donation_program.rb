class DonationProgram < ApplicationRecord
  # Relationships
  # -----------------------------
  has_many :donation_histories
  has_many :constituents, through: :donation_histories

  # Scopes
  # -----------------------------
    scope :alphabetical, -> { order('program') }


  # Validations
  # -----------------------------
  validates :program, presence:true



  # Other methods
  # -------------

end
