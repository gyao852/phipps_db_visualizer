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
                  :before_or_on => :end_date_time
  validates_datetime :end_date_time,
                  :after_or_on => :start_date_time,
                  :allow_blank => :true



  # Other methods
  # -------------
  def self.import(file)
    CSV.foreach(file.path, headers:true) do |row|
      date_string_1=row[2]
      row[2]=Date.strptime(date_string_1, '%m/%d/%Y')
      date_string_2=row[3]
      row[3]=Date.strptime(date_string_2, '%m/%d/%Y')
      Event.create! row.to_hash 
    end
  end 


end
