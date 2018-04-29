class UncleanAddress < ApplicationRecord
	self.primary_key = 'address_id'
    belongs_to :unclean_constituent, :foreign_key => :lookup_id
end
