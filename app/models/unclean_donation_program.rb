class UncleanDonationProgram < ApplicationRecord
	self.primary_key = 'donation_program_id'
    has_many :unclean_donation_histories, foreign_key: 'donation_program_id'
    has_many :unclean_constituents, through: :unclean_donation_histories
end
