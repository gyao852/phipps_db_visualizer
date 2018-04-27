class UncleanConstituentEvent < ApplicationRecord
    belongs_to :unclean_constituent, :foreign_key => :lookup_id
    belongs_to :unclean_event, :foreign_key => :event_id
end
