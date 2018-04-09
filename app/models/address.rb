class Address < ApplicationRecord
  # Relationships
  # -----------------------------
    belongs_to :constituent, :foreign_key => :lookup_id

# Scopes
 # -----------------------------
    scope :order_address_id, -> {order(:address_id)}
    scope :alphabetical_city, -> {order(:city)}
    scope :alphabetical_state, -> {order(:state)}
    scope :chronological_zip, -> {order(:zip)}
    scope :alphabetical_country, -> {order(:country)}

    scope :home, -> {where(address_type: "Home")}
    scope :business, -> {where(address_type: "Business")}
    scope :billing, -> {where(address_type: "Billing")}
    scope :work, -> {where(address_type: "Work")}
    scope :previous_address, -> {where(address_type: "Previous Address")}
    scope :seasonal, -> {where(address_type: "Seasonal")}
    scope :for_type, -> (aType){where(type: aType)}
    scope :for_lookup_id, -> (aLookup_id){where(type: aLookup_id)}
    scope :for_zip, -> (aZip){where(type: aZip)}
    scope :for_city, -> (aCity){where(type: aCity)}
    scope :for_address, -> (aAddress){where("address_1 LIKE ?", "%#{aAddress}%")}
    scope :for_state, -> (aState){where("state LIKE ?", "%#{aState}%")}
    scope :for_country, -> (aCountry){where("country LIKE ?", "%#{aCountry}%")}

 # Validations
 # -----------------------------
 # validates address_1
  validates :lookup_id, presence: true
  validates :address_1, presence: true, allow_blank:false
  validates_format_of :address_1, without: /\A(.*[A a]ve[.]).*\z/i, message: "cannot contain abbriviations"
  validates_format_of :address_1, without: /\A(.*[D d]r[.]).*\z/i, message: "cannot contain abbriviations"
  validates_format_of :address_1, without: /\A(.*[S s]t[.]).*\z/i, message: "cannot contain abbriviations"
  validates_format_of :address_1, without: /\A(.*[A a]pt[.]?).*\z/i, message: "cannot contain abbriviations"
  validates_format_of :address_1, without: /\A(.*[B b]lvd[.]?).*\z/i, message: "cannot contain abbriviations"
  validates_format_of :address_1, without: /\A(.*[R r]d[.]?).*\z/i, message: "cannot contain abbriviations"

  # # validates city capitalization
  validates :city, format: { with: /[A-Z]{1}[a-z A-Z]+(?:[\s-][A-Z]+)*/i , message: "City must be capitalized"}
  # # validates states
  STATES_LIST = ['Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut',
  'Delaware', 'District of Columbia', 'Florida', 'Georgia', 'Hawaii', 'Idaho', 'Illinois', 'Indiana',
  'Iowa', 'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota',
  'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey', 'New Mexico',
  'New York', 'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island',
  'South Carolina', 'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington', 'West Virginia',
  'Wisconsin', 'Wyoming']
  validates_inclusion_of :state, in: STATES_LIST, message: "is not a valid state"
  validates :country, :allow_blank => true, format:
  { with: /\A[A-Z][a-z A-Z]+(?:[\s-][A-Z]+)*\z/i ,
    message: "Country must be capitalized"}

  validates_date :date_added, :before => lambda {Date.today}, allow_blank:true

  validates :zip, :allow_blank => true, format:
  {with:/\A\d{5}(?:[-]\w{4})?|[A-Z][0-9][A-Z][0-9][A-Z][0-9]\z/i,
    message: "ZIP code is invalid"}

	# Other methods
 	# -------------
  def full_address
    "#{address_1}, #{city}, #{state}, #{zip}, #{country}"
  end

  def self.import(file)
    CSV.foreach(file.path, headers:true) do |row|
      if row[7] != nil
        # date_string = row[7]
        # date_string[0]="1"
        # date_string[2]="1"
        row[7] = nil #Date.strptime(date_string, '%m/%d/%Y')
        Address.create! row.to_hash
      else
        Address.create! row.to_hash
      end
    end
  end




end
