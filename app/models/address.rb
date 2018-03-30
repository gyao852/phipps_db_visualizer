class Address < ApplicationRecord
  # Relationships
 # -----------------------------
 belongs_to :Constituent

 # Scopes
 # -----------------------------


 # Validations
 # -----------------------------
 # validates address_1
 validates_format_of :address_1, without: /Ave/i, message: "cannot contain abbriviations"
 validates_format_of :address_1, without: /Dr/i, message: "cannot contain abbriviations"
 validates_format_of :address_1, without: /St/i, message: "cannot contain abbriviations"
 validates_format_of :address_1, without: /Apt/i, message: "cannot contain abbriviations"
 validates_format_of :address_1, without: /Blvd/i, message: "cannot contain abbriviations"
 validates_format_of :address_1, without: /Rd/i, message: "cannot contain abbriviations"
 # validates address_2
 validates_format_of :address_2, without: /Ave/i, message: "cannot contain abbriviations"
 validates_format_of :address_2, without: /Dr/i, message: "cannot contain abbriviations"
 validates_format_of :address_2, without: /St/i, message: "cannot contain abbriviations"
 validates_format_of :address_2, without: /Apt/i, message: "cannot contain abbriviations"
 validates_format_of :address_2, without: /Blvd/i, message: "cannot contain abbriviations"
 validates_format_of :address_2, without: /Rd/i, message: "cannot contain abbriviations"
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

#
validates :country, format: { with:/\A[a-zA-Z]+(?:[\s-][a-zA-Z]+)*\z/i , message: "Country must be capitalized"}




 # Other methods
 # -------------




end
