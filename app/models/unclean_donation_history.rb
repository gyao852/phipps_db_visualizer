class UncleanDonationHistory < ApplicationRecord
    belongs_to :unclean_constituent, :foreign_key => :lookup_id
    belongs_to :unclean_donation_program, :foreign_key => :donation_program_id
end
