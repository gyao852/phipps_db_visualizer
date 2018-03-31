class ConstituentEvent < ApplicationRecord
  # Relationships
  # -----------------------------
  belongs_to :Constituent
  belongs_to :Event


  # Scopes
  # -----------------------------


  # Validations
  # -----------------------------
  validates :looku_id, presence:true
  validates :event_id, presence:true



  # Other methods
  # -------------
end
