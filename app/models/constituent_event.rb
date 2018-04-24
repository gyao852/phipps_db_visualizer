class ConstituentEvent < ApplicationRecord
  # Relationships
  # -----------------------------
  belongs_to :event, :foreign_key => :event_id
  belongs_to :constituent,:foreign_key => :lookup_id, :primary_key => :lookup_id
  


  # Scopes
  # -----------------------------


  # Validations
  # -----------------------------
  validates :lookup_id, presence:true
  validates :event_id, presence:true



  # Other methods
  # -------------
  def self.import(file)
    CSV.foreach(file.path, headers:true) do |row|
      ConstituentEvent.create! row.to_hash
    end
  end
end
