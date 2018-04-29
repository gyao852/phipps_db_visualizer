class UncleanDonationHistory < ApplicationRecord
	self.primary_key = 'donation_history_id'
    belongs_to :unclean_constituent, :foreign_key => :lookup_id
    belongs_to :unclean_donation_program, :foreign_key => :donation_program_id
end
