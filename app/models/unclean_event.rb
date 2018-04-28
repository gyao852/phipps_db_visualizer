class UncleanEvent < ApplicationRecord
    has_many :unclean_constituent_events, foreign_key: "membership_id"
    has_many :constituents, through: :unclean_constituent_events
end
