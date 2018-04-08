class Event < ApplicationRecord
  # Relationships
  # -----------------------------
  has_many :constituent_events, foreign_key: 'event_id'
  has_many :constituents, through: :constituent_events

  # Scopes
  # -----------------------------


  # Validations
  # -----------------------------
  validates :event_id, presence:true
  validates :event_name, presence:true
  validates_datetime :start_date_time,
                  :before => :end_date_time
  validates_datetime :end_date_time,
                  :after => :start_date_time,
                  :allow_blank => :true



  # Other methods
  # -------------

end
