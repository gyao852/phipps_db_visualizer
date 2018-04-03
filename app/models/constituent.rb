class Constituent < ApplicationRecord
  # Relationships
  # -----------------------------
  has_many :addresses
  has_many :donation_histories
  has_many :donation_programs, through: :donation_histories
  has_many :constituent_events
  has_many :events, through: :constituent_events
  has_many :contact_histories
  has_many :constituent_membership_records
  has_many :membership_records, through: :constituent_membership_records

  # Scopes
  # -----------------------------
    scope :alphabetical, -> { order('name') }
    scope :by_lookup_id, -> {order(:lookup_id)}
    scope :alphabetical_last_group, -> {order(:last_group)}
    scope :alphabetical_name, -> {order(:name)}
    scope :individual, -> {where(constituent_type: "Individual")}
    scope :household, -> {where(constituent_type: "Household")}
    scope :company, -> {where(constituent_type: "Organization")}
  #
  # Validations
  # -----------------------------
  validates :lookup_id, presence: true
  # no validations for suffix
  # no validations for title
  # check
  # validates :name, format: { with: /\A[A-Z]\w+\-?\w+?\z/ , message: "Name field cannot contain special characters"}, presence: true
  # check
  validates :last_group, presence: true , format: { with: /\A[A-Z]\w+\-?\w+?\z/ , message: "Last_group field cannot contain special characters"}
  validates :phone, format: { with: /\A\(([0-9]{3})\)[-]([0-9]{3})[-]([0-9]{4})\z/ , message: "format of phone number is incorrect"}
  validates :email_id, format: { with:/\A[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}\z/, message: "format of email address is incorrect"}
  validates_inclusion_of :do_not_email, :in => [true,false]
  # validates :do_not_email, presence: true, allow_blank: true
  validates_date :dob, before: Date.today

  #
  # Other methods
  # -------------
  def current_address
   # map all addresses that belong to the constituent
   all_addresses = self.addresses
   curr = all_addresses.order(date_added: :desc).first
   if curr.nil?
     return nil
     #return "No address available"
   else
    return curr.address_1
   end
 end

 def current_membership_level
   #self.lookup_id
   curr = self.constituent_membership_records.membership_records.current.first
   if curr.nil?
     return nil
     #return "No membership available"
   else
    return curr.membership_level
   end
 end

 def current_membership_scheme
   #self.lookup_id
   curr = self.constituent_membership_records.membership_records.current.first
   if curr.nil?
     return nil
     #return "No membership available"
   else
    return curr.membership_scheme
   end
 end

  def self.import(file)
    CSV.foreach(file.path, headers:true) do |row|
      date_string = row[7]
      row[7] = Date.strptime(date_string, '%m/%d/%Y')
      Constituent.create! row.to_hash
    end
  end


  private
  # Entry point A:
  # This is a test commment
  # asdfasdfasdf

  # address_or_email
  #   return true
  # end

  #asdfasdfasdf
end
