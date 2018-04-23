class MembershipRecord < ApplicationRecord
  # Relationships
  # -----------------------------
  has_many :constituent_membership_records, foreign_key: "membership_id"
  has_many :constituents, through: :constituent_membership_records


  # Scopes
  # -----------------------------
    scope :current, -> { where('end_date >= ?', Date.today)}

  # Validations
  # -----------------------------
  # Validations
  # -----------------------------
  # validates :membership_id, presence: true
  # validates :membership_scheme, presence:true
  # validates :membership_level, presence:true
<<<<<<< HEAD
  # # no validations for add-ons as it is a feature the client will start to use in the future
  # # validations on membership level type??
  # validates :membership_status, presence:true
  # # validate start date on or before today
  # validates_date :start_date,
  #                 :before => lambda{Date.today}
  # # validate end date after start date
  # validates_date :end_date,
  #                 :after => :start_date
  # # validate last renewed after start date and before end date
=======
  # no validations for add-ons as it is a feature the client will start to use in the future
  # validations on membership level type??
  # validates :membership_status, presence:true
  # validate start date on or before today
  # validates_date :start_date,
  #                 :before => lambda{Date.today}
  # validate end date after start datethis i
  # validates_date :end_date,
  #                 :after => :start_date
  # validate last renewed after start date and before end date
>>>>>>> minnie
  # validates_date :last_renewed,
  #                 :on_or_before => :end_date,
  #                 :on_or_after => :start_date,
  #                 :allow_blank => :true

  # Other methods
  # -------------
  def self.import(file)
    CSV.foreach(file.path, headers:true) do |row|
      # if row[9] != nil
      #   date_string = row[7]
      #   row[7] = Date.strptime(date_string, '%m/%d/%Y')
      #   date_string_2 = row[8]
      #   row[8] = Date.strptime(date_string_2, '%m/%d/%Y')
      #   date_string_3 = row[9]
      #   row[9] = Date.strptime(date_string_3, '%m/%d/%Y')
      #   MembershipRecord.create! row.to_hash
      # else
      #   date_string = row[7]
      #   row[7] = Date.strptime(date_string, '%m/%d/%Y')
      #   date_string_2 = row[8]
      #   row[8] = Date.strptime(date_string_2, '%m/%d/%Y')
       
      # end
       MembershipRecord.create! row.to_hash
    end
  end


end
