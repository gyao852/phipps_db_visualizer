class ContactHistory < ApplicationRecord
  # Relationships
  # -----------------------------
  belongs_to :constituent,  :foreign_key => :lookup_id, :primary_key => :lookup_id
  

  # Scopes
  # -----------------------------
  scope :on_or_before, -> (date) {where("date <= ?", date)}
  scope :on_or_after, -> (date) {where("date >= >>", date)}
  scope :chronological, -> {order ('date DESC')}


  # Validations
  # -----------------------------
  validates :lookup_id, presence:true
  # validates :date, presence:true
  # validates_date :date



  # Other methods
  # -------------

  # generate report of constituents who have not been contacted since a certain date
  def self.import(file)
    CSV.foreach(file.path, headers:true) do |row|
      ContactHistory.create! row.to_hash 
    end
  end 
end
