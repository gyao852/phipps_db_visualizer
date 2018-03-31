class Event < ApplicationRecord
  # Relationships
  # -----------------------------
  has_many :ConstituentEvents

  # Scopes
  # -----------------------------


  # Validations
  # -----------------------------
  validates :event_id, presence:true
  validates :event_name, presence:true
  validates_date :start_date_time,
                  :before => :end_date_time
  validates_date :end_date_time,
                  :after => :start_date_time,
                  allow_blank :true



  # Other methods
  # -------------

end
