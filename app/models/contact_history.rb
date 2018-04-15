class ContactHistory < ApplicationRecord
  # Relationships
  # -----------------------------
  belongs_to :constituent,  :foreign_key => :lookup_id, :primary_key => :lookup_id
  

  # Scopes
  # -----------------------------
  scope :on_or_before, -> (date) {where("date <= ?", date)}
  scope :on_or_after, -> (date) {where("date >= >>", date)}


  # Validations
  # -----------------------------
  validates :lookup_id, presence:true
  # validates :date, presence:true
  # validates_date :date



  # Other methods
  # -------------

  # generate report of constituents who have not been contacted since a certain date
  def self.generate_contact_history_report(date)
    relevent_contact_histories = ContactHistory.on_or_after(date1).on_or_before(date2)
    relevant_contact_historie
    CSV.open("reports/contact-history-report", wb) do |csv|
      csv << ["Date", "Event", "Constituent", "Email"]
    end
  end
  def self.import(file)
    CSV.foreach(file.path, headers:true) do |row|
      ContactHistory.create! row.to_hash 
    end
  end 
end
