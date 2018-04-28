class UncleanContactHistory < ApplicationRecord
    belongs_to :unclean_constituent, :foreign_key => :lookup_id
end
