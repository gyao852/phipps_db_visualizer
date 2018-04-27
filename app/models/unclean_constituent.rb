class UncleanConstituent < ApplicationRecord
	has_many :unclean_addresses, foreign_key: "lookup_id"
  	has_many :unclean_donation_histories, foreign_key: "lookup_id"
  	has_many :unclean_donation_programs, through: :unclean_donation_histories
  	has_many :unclean_constituent_events, foreign_key: "lookup_id"
  	has_many :unclean_events, through: :unclean_constituent_events
  	has_many :unclean_contact_histories, foreign_key: "lookup_id"
  	has_many :unclean_constituent_membership_records, foreign_key: "lookup_id"
	has_many :unclean_membership_records, through: :unclean_constituent_membership_records
	

 	scope :duplicates, -> {where(duplicate: true)}

	def current_address
		all_addresses = self.unclean_addresses
		curr = all_addresses.order(date_added: :desc).first
		if curr.nil?
			return nil
		else
			return curr.address_1
	 	end
	end

	 def full_name
	 	"#{name}"
	 end

	def current_membership_level
		if self.unclean_membership_records.current.blank?
			return nil
		else
			curr = self.unclean_membership_records.current.first.membership_level
			return curr
	    end
	end

	def current_membership_scheme
		if self.unclean_membership_records.current.blank?
			return nil
		else
			curr = self.unlcean_membership_records.current.first.membership_scheme
			return curr
		end
	end

	


end
