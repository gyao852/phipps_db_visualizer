class Constituent < ApplicationRecord
  # Relationships
  # -----------------------------
  self.primary_key = 'lookup_id'
  has_many :addresses, foreign_key: "lookup_id"
  has_many :donation_histories, foreign_key: "lookup_id"
  has_many :donation_programs, through: :donation_histories
  has_many :constituent_events, foreign_key: "lookup_id"
  has_many :events, through: :constituent_events
  has_many :contact_histories, foreign_key: "lookup_id"
  has_many :constituent_membership_records, foreign_key: "lookup_id"
  has_many :membership_records, through: :constituent_membership_records

  # Scopes
  # -----------------------------
  # This a test
    scope :by_lookup_id, -> {order(:lookup_id)}
    scope :alphabetical_last_group, -> {order(:last_group)}
    scope :alphabetical_name, -> {order(:name)}
    scope :individual, -> {where(constituent_type: "Individual")}
    scope :household, -> {where(constituent_type: "Household")}
    scope :company, -> {where(constituent_type: "Organization")}
  #
  # Validations
  # -----------------------------
  # validates :lookup_id, presence: true
  # validates :last_group, presence: true
  # validates :phone, format: {with: /\A\(?\d{3}\)[-]\d{3}[-]\d{4}\z/i,
  #   message: "phone number is not valid"}
  # validates :email_id, format: {with:
  #   /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
  #   message: "e-mail format is not valid."}
  # validates :do_not_email, :inclusion => {:in => [true, false]}
  # validates :name, presence: true
  # validates :phone, format: { with: /\A\([0-9]{3}\)-[0-9]{3}-[0-9]{4}\z/i , message: "format of phone number is incorrect"}
  # validates :email_id, format: { with:/\A[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}\z/i, message: "format of email address is incorrect"}
  # validates_inclusion_of :do_not_email, :in => [true,false]

  # validates :last_group, presence: true
  # validates_date :dob, before: Date.today, :allow_blank => true


  #
  # Other methods
  # -------------
  def current_address
   # map all addresses that belong to the constituent
   all_addresses = self.addresses

   curr = all_addresses.order(date_added: :desc).first
    if curr.nil?
      return nil
    else
      return curr.address_1
    end
  end

  def full_name
    "#{name}"
  end

  def current_membership_level
    if self.membership_records.current.blank?
      return nil
    else
      curr = self.membership_records.current.first.membership_level
      return curr
    end
  end
  
  # def current_membership_level
  #    if self.constituent_membership_records.current.blank?
  #      return nil
  #    else
  #      curr = self.constituent_membership_records.current.first.membership_record
  #      return curr.membership_level
  #    end
  #  end

  def current_membership_scheme
    if self.membership_records.current.blank?
      return nil
    else
      curr = self.membership_records.current.first.membership_scheme
      return curr
    end
  end

  # def current_membership_scheme
  #  if self.constituent_membership_records.current.blank?
  #    return nil
  #  else
  #    curr = self.constituent_membership_records.current.first.membership_record
  #    return curr.membership_scheme
  #  end
  # end

  def self.import(file)
    CSV.foreach(file.path, headers:true) do |row|
      if row[7] != nil
        # date_string = row[7]
        # date_string[0]="1"
        # date_string[2]="1"
        row[7] = nil #Date.strptime(date_string, '%m/%d/%Y')
        Constituent.create! row.to_hash
      else
        Constituent.create! row.to_hash
      end
    end
  end



  private

end
