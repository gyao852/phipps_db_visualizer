class DonationHistory < ApplicationRecord
  # Relationships
  # -----------------------------
  belongs_to :constituent, :foreign_key => :lookup_id, :primary_key => :lookup_id
  belongs_to :donation_program, :foreign_key => :donation_program_id
  # test

  # Scopes
  # -----------------------------
  # This is a test. 

  # Validations
  # -----------------------------
  #compulsory fields
  validates_presence_of :donation_history_id
  # validates_presence_of :lookup_id
  validates_presence_of :amount
  validates_numericality_of :amount, :greater_than => 0
  validates_presence_of :date
  validates_date :date, :on_or_before => Date.today
  validates_presence_of :payment_method
  validates_inclusion_of :do_not_acknowledge, :in => [true,false]
  validates_inclusion_of :given_anonymously, :in => [true,false]
  validates_presence_of :transaction_type

  # Scopes
  scope :on_or_before, -> (date) {where("date <= ?", date)}
  scope :on_or_after,  -> (date) {where("date >= ?", date)}

  # Class Method
 
  
  # Other methods
  # -------------


 
  



  private

end
