class MembershipRecord < ApplicationRecord
  # Relationships
  # -----------------------------
  has_many :constituent_membership_records


  # Scopes
  # -----------------------------
    scope :current, -> { where('end_date >= ?', Date.today)}

  # Validations
  # -----------------------------
  # Validations
  # -----------------------------
  validates :membership_id, presence: true
  validates :membership_scheme, presence:true
  validates :membership_level, presence:true
  # no validations for add-ons as it is a feature the client will start to use in the future
  # validations on membership level type??
  validates :membership_status, presence:true
  validates_numericality_of :term, :only_integer => true, :greater_than=> 0
  # validate start date on or before today
  validates_date :start_date,
                  :before => lambda{Date.today}
  # validate end date after start date
  validates_date :end_date,
                  :before => :start_date
  # validate last renewed after start date and before end date
  validates_date :last_renewed,
                  :before => :end_date,
                  :after => :start_date,
                  :allow_blank => :true

  # Other methods
  # -------------

end
