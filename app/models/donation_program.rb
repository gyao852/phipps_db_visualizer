class DonationProgram < ApplicationRecord
  # Relationships
  # -----------------------------
  self.primary_key = 'donation_program_id'
  has_many :donation_histories, foreign_key: 'donation_program_id'
  has_many :constituents, through: :donation_histories
  attr_accessor :goal

  # Scopes
  # -----------------------------
    scope :alphabetical, -> { order('program') }
    scope :for_program, -> (aProgram){where("program LIKE ?", "%#{aProgram}%")}


  # Validations
  # -----------------------------
  validates :program, presence:true



  # Other methods
  # -------------
  def self.for_other_programs
    return DonationProgram.all - DonationProgram.for_program("Annual Appeal") - 
      DonationProgram.for_program("Commemorative Certificates") -
      DonationProgram.for_program("Dicovery Garden") -
      DonationProgram.for_program("Sustained Giving") -
      DonationProgram.for_program("Childrens' Programs")
  end

  def self.check_giving_level(amount)
    if amount < 100
      return "<100"
    elsif amount >= 100 && amount < 250
      return "100-249"
    elsif amount >= 250 && amount < 500
      return "250-499"
    elsif amount >= 500 && amount < 1000
      return "500-999"
    elsif amount >= 1000 && amount <2500
      return "1000-2499"
    elsif amount >= 2500 && amount < 5000
      return "2500-4999"
    elsif amount >= 5000 && amount < 10000
      return "5000-9999"
    else
      return ">10000"
    end
  end

  # Levels is a hash of giving levels and their counts
  # EG: {}
  # returns hash with sum of donation amount and count of donations per giving level, defaults to current fiscal year
  def self.sum_and_count_level(program, startDate=Date.new(Date.today.year-1,10,1), endDate=Date.new(Date.today.year,9,30) )

    hash = {"program"=>program, "sum"=> 0, "<100"=>0,"100-249"=>0,"250-499"=>0,"500-999"=>0, 
          "1000-2499"=>0, "2500-4999"=>0, "5000-9999"=>0,">10000"=>0}
    if program == "Other"
      relevant_programs = DonationProgram.for_other_programs
    else
      relevant_programs = DonationProgram.for_program(program)
    end
    # need this outer loop because more than one program might be returned by the scope
    relevant_programs.each do |p|
      histories = p.donation_histories.on_or_after(startDate).on_or_before(endDate)
        histories.each do |h|
          hash["sum"] += h.amount
          lv = check_giving_level(h.amount)
          # increment count of such donation by 1
          hash[lv] += 1
        end
    end
    return hash
  end
  
  def self.import(file)
    CSV.foreach(file.path, headers:true) do |row|
      DonationProgram.create! row.to_hash
    end
  end


end
