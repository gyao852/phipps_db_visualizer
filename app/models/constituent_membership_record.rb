class ConstituentMembershipRecord < ApplicationRecord
  # Relationships
  # -----------------------------
  belongs_to :constituent,:foreign_key => :lookup_id, :primary_key => :lookup_id
  belongs_to :membership_record, :foreign_key => :membership_id, :primary_key => :membership_id


  # Scopes
  # -----------------------------


  # Validations
  # -----------------------------
  validates :lookup_id, presence:true
  validates :membership_id, presence:true



  # Other methods
  # -------------
  def self.import(file)
    CSV.foreach(file.path, headers:true) do |row|
      if row[1] != nil
        ConstituentMembershipRecord.create! row.to_hash
      end
    end
  end

end
