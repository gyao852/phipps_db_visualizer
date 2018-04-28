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
	 scope :incomplete_names, ->{where(incomplete_names: true)}
	 scope :no_contact, -> {where(no_contact: true)}
	 scope :invalid_emails, ->{where(invalid_emails: true)}
	 scope :invalid_phones, -> {where(invalid_phones: true)}
	 scope :invalid_zips, -> {where(invalid_zips: true)}  
	 scope :invalid, -> {where('invalid_emails OR invalid_phones')}
	 scope :incomplete_names, -> {where(incomplete_names: true)}
	 scope :duplicate_scope, -> {where(duplicate: true)}
	 

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

	# Class methods to generate reports
	def self.generate_no_contact
		filename = 'reports/no-contact-report-'+DateTime.current.strftime("%m%d%Y%H%M%S")+".csv"
		nc = UncleanConstituent.no_contact
		CSV.open(filename, 'wb') do |csv|
			csv << ['Lookup ID', 'Name']
			toAppend = []
			nc.each do |row|
				toAppend[0] = row.lookup_id
				toAppend[1] = row.name
				csv << toAppend
			end
		end
	end

	def self.generate_incomplete_names
		filename = 'reports/incomplete-names-report-'+DateTime.current.strftime("%m%d%Y%H%M%S")+".csv"
		inc_names = UncleanConstituent.incomplete_names
		CSV.open(filename, 'wb') do |csv|
			csv << ['Lookup ID', 'Name', 'Last/Group Name']
			toAppend = []
			inc_names.each do |row|
				toAppend[0] = row.lookup_id
				toAppend[1] = row.name
				toAppend[2] = row.last_group
			end
		end
	end

	def self.generate_all_invalid
		filename = 'reports/invalid-records-report-'+DateTime.current.strftime("%m%d%Y%H%M%S")+".csv"
		i = UncleanConstituent.invalid
		CSV.open(filename,'wb') do |csv|
			csv << ['LookupID', 'Name', 'Email', 'Phone']
			toAppend = []
			i.each do |row|
				toAppend[0] = row.lookup_id
				toAppend[1] = row.name
				toAppend[2] = row.email_id
				toAppend[3] = row.phone
			end
		end
	end

	def self.generate_invalid_emails
		filename = 'reports/invalid-email-report-'+DateTime.current.strftime("%m%d%Y%H%M%S")+".csv"
		ie = UncleanConstituent.invalid_emails
		CSV.open(filename, 'wb') do |csv|
			csv << ['LookupID', 'Name', 'Invalid Email']
			toAppend = []
			ie.each do |row|
				toAppend[0] = row.lookup_id
				toAppend[1] = row.name
				toAppend[2] = row.email_id
				csv << toAppend
			end
		end
	end

	def self.generate_invalid_phones
		filename = 'reports/invalid-phone-numbers-report-'+DateTime.current.strftime("%m%d%Y%H%M%S")+".csv"
		ip = UncleanConstituent.invalid_phones
		CSV.open(filename,'wb') do |csv|
			csv << ['LookupID', 'Name', 'Invalid Phone']
			toAppend = []
			ip.each do |row|
				toAppend[0] = row.lookup_id
				toAppend[1] = row.name
				toAppend[2] = row.phone
				csv << toAppend
			end
		end
	end

	# def self.generate_invalid_zips
	# 	filename = 'reports/invalid-zip-report-'+DateTime.current.strftime("%m%d%Y%H%M%S")+'.csv'
	# 	iz = UncleanConstituent.invalid_zips
	# 	CSV.open(filename, 'wb') do |csv|
	# 		csv << ['LookupID','Name','Invalid Zip']
	# 		toAppend = []
	# 		iz.each do |row|
	# 			toAppend[0] = row.lookup_id
	# 			toAppend[1] = row.name
	# 			toAppend[2] = row.zip
	# 			csv << toAppend
	# 		end
	# 	end
	# end

	def self.generate_duplicates
		filename = 'reports/duplicate-constituents-'+DateTime.current.strftime("%m%d%Y%H%M%S")+'.csv'
		d = UncleanConstituent.duplicate_scope
		CSV.open(filename, 'wb') do |csv|
			csv << ['LookupID', 'Name', 'Duplicate_Lookup_Ids']
			toAppend = []
			d.each do |row|
				toAppend[0] = row.lookup_id
				toAppend[1] = row.name
				toAppend[2] = row.duplicate_lookup_ids
				csv << toAppend
			end
		end

	end




	

end