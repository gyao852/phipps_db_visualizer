class DonationProgram < ApplicationRecord
  # Relationships
  # -----------------------------
  has_many :donation_histories, foreign_key: 'donation_program_id'
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
