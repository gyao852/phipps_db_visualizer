class DonationProgram < ApplicationRecord
  # Relationships
  # -----------------------------
  has_many :donation_histories, foreign_key: 'donation_program_id'
  has_many :constituents, through: :donation_histories

  # Scopes
  # -----------------------------
    scope :alphabetical, -> { order('program') }
    scope :for_program, -> (aProgram){where("program LIKE ?", "%#{aProgram}%")}

  # Validations
  # -----------------------------
  validates :program, presence:true



  # Other methods
  # -------------
  def self.import(file)
    CSV.foreach(file.path, headers:true) do |row|
      DonationProgram.create! row.to_hash
    end
  end


end
