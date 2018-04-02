class ConstituentEvent < ApplicationRecord
  # Relationships
  # -----------------------------
  belongs_to :Constituent,:foreign_key => :lookup_id, :primary_key => :lookup_id
  belongs_to :Event, :foreign_key => :event_id, :primary_key => :event_id


  # Scopes
  # -----------------------------


  # Validations
  # -----------------------------
  validates :looku_id, presence:true
  validates :event_id, presence:true



  # Other methods
  # -------------
end
