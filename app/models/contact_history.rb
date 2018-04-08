class ContactHistory < ApplicationRecord
  # Relationships
  # -----------------------------
  belongs_to :constituent,  :foreign_key => :lookup_id, :primary_key => :lookup_id
  

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
  def self.import(file)
    CSV.foreach(file.path, headers:true) do |row|
      ContactHistory.create! row.to_hash 
    end
  end 
end
