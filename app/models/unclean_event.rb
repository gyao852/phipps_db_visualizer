class UncleanEvent < ApplicationRecord
	self.primary_key = 'event_id'
    has_many :unclean_constituent_events, foreign_key: "membership_id"
    has_many :constituents, through: :unclean_constituent_events
end
