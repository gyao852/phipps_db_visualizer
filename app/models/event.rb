class Event < ApplicationRecord
  # Relationships
  # -----------------------------
  self.primary_key = 'event_id'
  has_many :constituent_events, foreign_key: 'event_id'
  has_many :constituents, through: :constituent_events

  # Scopes
  # ---------------------------
  scope :on_or_before, -> (date) {where("start_date_time <= ?", date)}
  scope :on_or_after, -> (date) {where("start_date_time >= ?", date)}
  scope :chronological, -> {order 'start_date_time DESC'}

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
  def count_rsvp
    count = 0
    self.constituent_events.each do |ce|
      if ce.status == 'Yes'
        count += 1
      end
    end
    return count
  end

  def self.generate_attendance_report(selected_event_id)
    puts selected_event_id
    result = CSV.generate do |csv|
      csv << ["Date", "Event"]
      csv << [Event.find_by(event_id:selected_event_id.to_s).start_date_time, Event.find_by(event_id:selected_event_id.to_s).event_name]
      csv << ["Constituent", "Email", "RSVP", "Attendance"]
      relevant_ce = ConstituentEvent.where(event_id: selected_event_id)
      relevant_ce.each do |ce|
        csv << [ce.constituent.name, ce.constituent.email_id, ce.status, ce.attend]
      end
    end
    return result
  end

  # def self.generate_event_report(start_date, end_date)
  #   relevant_events = Event.on_or_after(start_date).on_or_before(end_date)
  #   relevant_events.each do |e|
  #     event_hash = {Date: e.start_date_time, Event: e.event_name, Constituents: [], Emails: []}
  #     e.constituent_events.each do |ce|
  #     end
  #   end
  #   # edit the report string
  #   CSV.open("reports/event-report.csv", "wb") do |csv|
  #     csv << ["Date", "Event", "Constituent", "Email"]
  #   end
  # end

  def self.import(file)
    CSV.foreach(file.path, headers:true) do |row|
      Event.create! row.to_hash 
    end
  end 


end
