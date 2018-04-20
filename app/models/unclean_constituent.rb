class UncleanConstituent < ApplicationRecord
	has_many :addresses, foreign_key: "lookup_id"
  	has_many :donation_histories, foreign_key: "lookup_id"
  	has_many :donation_programs, through: :donation_histories
  	has_many :constituent_events, foreign_key: "lookup_id"
  	has_many :events, through: :constituent_events
  	has_many :contact_histories, foreign_key: "lookup_id"
  	has_many :constituent_membership_records, foreign_key: "lookup_id"
  	has_many :membership_records, through: :constituent_membership_records

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
		if self.membership_records.current.blank?
			return nil
		else
			curr = self.membership_records.current.first.membership_level
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
