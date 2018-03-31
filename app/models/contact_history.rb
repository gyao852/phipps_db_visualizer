class ContactHistory < ApplicationRecord
  # Relationships
  # -----------------------------
  belongs_to :Constituent


  # Scopes
  # -----------------------------


  # Validations
  # -----------------------------
  validates :lookup_id, presence:true
  validates :type, presence:true
  validates :date, presence:true
  validates_date :date



  # Other methods
  # -------------

end
