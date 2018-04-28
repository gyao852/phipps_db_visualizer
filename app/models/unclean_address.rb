class UncleanAddress < ApplicationRecord
    belongs_to :unclean_constituent, :foreign_key => :lookup_id
end
