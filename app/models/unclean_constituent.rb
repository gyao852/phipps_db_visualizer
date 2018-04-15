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

	def self.import_file(file)
		unclean_constituents_array = []
		CSV.foreach(file.path.to_s, headers:true) do |row|
			unclean_constituents_array << Constituent.new(row.to_h)
		end
    	puts "array is"
    	puts unclean_constituents_array
    	puts "array is"
    	UncleanConstituent.import unclean_constituents_array, on_duplicate_key_ignore: true
    end

  # def self.import(file)
  #   CSV.foreach(file.path, headers:true) do |row|
  #     if row[7] != nil
  #       Constituent.create! row.to_hash
  #     else
  #       Constituent.create! row.to_hash
  #     end
  #   end
  # end


end
