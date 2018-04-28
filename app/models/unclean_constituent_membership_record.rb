class UncleanConstituentMembershipRecord < ApplicationRecord
    belongs_to :unclean_constituent, :foreign_key => :lookup_id, :primary_key => :lookup_id
    belongs_to :unclean_membership_record,:foreign_key => :membership_id, :primary_key => :membership_id
end
