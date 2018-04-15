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
  validates :lookup_id, presence: true
  validates :last_group, presence: true
  validates :name, presence: true
  validates :phone, format: {with: /\A\(?\d{3}\)[\s]\d{3}[-]\d{4}\z/i,
    message: "phone number is not valid"}, :allow_blank => true
  # validates :do_not_email, :inclusion => {:in => [true, false]}
  # validates_inclusion_of :do_not_email, :in => [true,false]
  validates_date :dob, before: Date.today, :allow_blank => true
  validates :email_id, format: { with:/.+@.+\..+/i,
  message: "format of email address is incorrect"}, :allow_blank => true





  #
  # Other methods
  # -------------
  def most_recently_contacted_date
    return self.contact_histories.chronological.first.date
  end

  def self.last_contacted_before(date)
    to_contact = []
    Constituent.all.each do |c|
      unless c.contact_histories.nil? || c.contact_histories.empty?
        append = []
        if c.most_recently_contacted_date < date
          append = [c.name, c.email_id, c.do_not_email]
          to_contact.append(append)
        end
      end    
    end
    return to_contact

  end

  def self.generate_contact_history_report(date)
    to_contact = Constituent.last_contacted_before(date)
    CSV.open('reports/contact-history-report.csv','wb') do |csv|
      csv << ["Constituent", "Email", "Do Not Email"]
      to_contact.each do |row|
        csv << row
      end
    end
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

  # def self.import_file(file)
  #   constituents_array = []
  #   CSV.foreach(file.path.to_s, headers:true) do |row|
  #     constituents_array << Constituent.new(row.to_h)
  #   end
  #   puts "array is"
  #   puts constituents_array
  #   puts "array is"
  #   Constituent.import constituents_array, on_duplicate_key_ignore: true
  # end
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
