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
  validates_numericality_of :amount, :greater_than_equal_to => 0
  # validates_presence_of :date
  # validates_date :date, :on_or_before => Date.today
  # validates_presence_of :payment_method
  validates_inclusion_of :do_not_acknowledge, :in => [true,false]
  validates_inclusion_of :given_anonymously, :in => [true,false]
  validates_presence_of :transaction_type

  # Scopes
  scope :on_or_before, -> (date) {where("date <= ?", date)}
  scope :on_or_after,  -> (date) {where("date >= ?", date)}
  scope :chronological, -> {order 'date DESC'}
  # Class Method


  # Other methods
  # -------------

  def self.import(file)
    CSV.foreach(file.path, headers:true) do |row|
      # amount = row[3].to_i
      # row[3]=amount
      # date_string=row[4]
      # row[4]=Date.strptime(date_string, '%m/%d/%Y')
      if row[1] != nil
        DonationHistory.create! row.to_hash
      end
    end
  end 

  private
end
