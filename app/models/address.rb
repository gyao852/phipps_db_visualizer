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

    scope :for_type, -> (aType){where(type: aType)}
    scope :for_lookup_id, -> (aLookup_id){where(type: aLookup_id)}
    scope :for_country, -> (aCountry){where(type: aCountry)}
    scope :for_zip, -> (aZip){where(type: aZip)}
    scope :for_city, -> (aCity){where(type: aCity)}
    scope :for_state, -> (aState){where(type: aState)}
    # Did not add scope to search for address yet

 # Validations
 # -----------------------------
 # validates address_1
  # validates_format_of :address_1, without: /Ave/i, message: "cannot contain abbriviations"
  # validates_format_of :address_1, without: /Dr/i, message: "cannot contain abbriviations"
  # validates_format_of :address_1, without: /St/i, message: "cannot contain abbriviations"
  # validates_format_of :address_1, without: /Apt/i, message: "cannot contain abbriviations"
  # validates_format_of :address_1, without: /Blvd/i, message: "cannot contain abbriviations"
  # validates_format_of :address_1, without: /Rd/i, message: "cannot contain abbriviations"

  # validates city capitalization
  validates :city, format: { with:/\A[a-zA-Z]+(?:[\s-][a-zA-Z]+)*\z/i , message: "City must be capitalized"}
  # validates states
  STATES_LIST = ['Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut',
  'Delaware', 'District of Columbia', 'Florida', 'Georgia', 'Hawaii', 'Idaho', 'Illinois', 'Indiana',
  'Iowa', 'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota',
  'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey', 'New Mexico',
  'New York', 'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island',
  'South Carolina', 'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington', 'West Virginia',
  'Wisconsin', 'Wyoming']
   validates_inclusion_of :state, in: STATES_LIST, message: "is not an option"

   # validates :country, format: { with:/\A[a-zA-Z]+(?:[\s-][a-zA-Z]+)*\z/i , message: "Country must be capitalized"}
  # validates_date :


	# Other methods
 	# -------------
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
