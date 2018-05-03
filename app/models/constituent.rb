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
    scope :individuals, -> {where(constituent_type: "Individual")}
    scope :households, -> {where(constituent_type: "Household")}
    scope :organizations, -> {where(constituent_type: "Organization")}

  #
  # Validations
  # -----------------------------
  validates :lookup_id, presence: true
  validates :last_group, presence: true
  validates :name, presence: true
  validates :phone, format: {with: /\A\(?\d{3}\)[\s]\d{3}[-]\d{4}\z/i,
    message: "phone number is not valid"}, :allow_blank => true
  # validates :do_not_email, :inclusion => {:in => [true, false]}
  # validates_inclusion_of :do_not_email, :in => [true,false]
  # validates_date :dob, before: Date.today, :allow_blank => true
  validates :email_id, format: { with:/.+@.+\..+/i,
  message: "format of email address is incorrect"}, :allow_blank => true





  #
  # Other methods
  # -------------
  def most_recent_donation
    return self.donation_histories.chronological.first
  end

  def self.last_donation_before(date)
    donations = []
    Constituent.all.each do |c|
      unless c.donation_histories.nil? || c.donation_histories.empty?
        append = []
        if c.most_recent_donation.date < date
          append = [c.name, c.email_id, c.most_recent_donation.date, c.most_recent_donation.amount]
          donations.append(append)
        end
      end
    end
    return donations
  end

  
  # generates report of constituents who have not donated after a certain date and most recent doantions they made
  def self.generate_donations_report(date)
    d = Date.parse(date)
    sql = "Select constituents.lookup_id, constituents.name, donation_histories.date, donation_histories.amount
           From constituents
           Join donation_histories
           On constituents.lookup_id = donation_histories.lookup_id
           where  constituents.lookup_id NOT IN (Select constituents.lookup_id
                                                           From constituents
                                                           Join donation_histories
                                                           On constituents.lookup_id = donation_histories.lookup_id
                                                           where donation_histories.date IS NOT NULL and donation_histories.date>'#{d}'
                                                           Group by constituents.lookup_id, donation_histories.amount)
            Order by constituents.lookup_id;"
    donations  = ActiveRecord::Base.connection.execute(sql)
    
    result = CSV.generate do |csv|
      csv << ["Constituent", "Email", "Last Donation Date", "Last Donation Amount"]
      donations.each_row do |row|
        puts row
        csv << row
      end
    end
    return result
  end

  def most_recently_contacted_date
    return self.contact_histories.chronological.first.date
  end

  # def self.last_contacted_before(date)
  #   to_contact = []
  #   Constituent.all.each do |c|
  #     unless c.contact_histories.nil? || c.contact_histories.empty?
  #       append = []
  #       if c.most_recently_contacted_date < date
  #         append = [c.name, c.email_id, c.do_not_email]
  #         to_contact.append(append)
  #       end
  #     end    
  #   end
  #   return to_contact
  # end

  def self.generate_contact_history_report(date)
    d = Date.parse(date)
    sql = "Select constituents.lookup_id, constituents.email_id, constituents.do_not_email, contact_histories.date
           From constituents
           Join contact_histories
           On constituents.lookup_id = contact_histories.lookup_id
           where constituents.lookup_id NOT IN(Select constituents.lookup_id
                                               From constituents
                                               Join contact_histories
                                               On constituents.lookup_id = contact_histories.lookup_id
                                               where contact_histories.date IS NOT NULL and contact_histories.date>'#{d}'
                                               Group by constituents.lookup_id) and constituents.email_id IS NOT NULL and contact_histories.date IS NOT NULL
            Order by constituents.lookup_id;"
    to_contact  = ActiveRecord::Base.connection.execute(sql)
    result = CSV.generate do |csv|
      csv << ["Constituent", "Email", "Do Not Email", "date"]
      to_contact.each_row do |row|
        csv << row
      end
    end
    return result
  end
  
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

  def current_membership_scheme
    if self.membership_records.current.blank?
      return nil
    else
      curr = self.membership_records.current.first.membership_scheme
      return curr
    end
  end

  def self.import_file(file)
    CSV.foreach(file.path, headers:true) do |row|
      if row[7] != nil
        Constituent.create! row.to_hash
      else
        Constituent.create! row.to_hash
      end
    end
  end
  
  private

end
