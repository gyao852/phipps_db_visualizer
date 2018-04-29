class UncleanMembershipRecord < ApplicationRecord
	self.primary_key = 'membership_id'
    has_many :unclean_constituent_membership_records, :primary_key => :lookup_id
    has_many :unclean_constituents, through: :unclean_constituent_membership_records


    scope :current, -> { where('end_date >= ?', Date.today)}
end
