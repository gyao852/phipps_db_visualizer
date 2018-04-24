class Import < ApplicationRecord

	attr_accessor :cmuteamconstituentsexport_file
	attr_accessor :cmuteameventattendanceexport_file
	attr_accessor :cmuteamcontacthistoryexport_file
	attr_accessor :cmuteamdonationsexport_file
	# attr_accessor :cmuTeamDonationProgramExport
	# attr_accessor :cmuTeamEventExport

	def initialize(cmuteamconstituentsexport_file=nil,cmuteameventattendanceexport_file=nil,cmuteamcontacthistoryexport_file=nil,cmuteamdonationsexport_file=nil)
		@cmuteamconstituentsexport_file = cmuteamconstituentsexport_file
		@cmuteameventattendanceexport_file = cmuteameventattendanceexport_file
		@cmuteamcontacthistoryexport_file = cmuteamcontacthistoryexport_file
		@cmuteamdonationsexport_file = cmuteamdonationsexport_file
		# @cmuTeamDonationsExport = cmuTeamDonationsExport
		# @cmuTeamEventExport = cmuTeamEventExport
	end

#############################################################
# upload files
#############################################################

	def save_cmuteamconstituentsexport_csv_file
		CSV.open("#{Rails.root}/public/CMU Team Constituents Export.csv", "wb") do |csv|
			CSV.foreach(cmuteamconstituentsexport_file.path, headers:false) do |row|
      			csv << row
    		end
		end
	end

	def save_cmuteameventattendanceexport_csv_file
		CSV.open("#{Rails.root}/public/CMU Team Event Attendance Export.csv", "wb") do |csv|
			CSV.foreach(cmuteameventattendanceexport_file.path, headers:false) do |row|
      			csv << row
    		end
		end
	end

	def save_cmuteamdonationsexport_csv_file
		CSV.open("#{Rails.root}/public/CMU Team Donations Export.csv", "wb") do |csv|
			CSV.foreach(cmuteamdonationsexport_file.path, headers:false) do |row|
      			csv << row
    		end
		end
	end

	def save_CMUTeamEventAttendanceExport_csv_file
		CSV.open("#{Rails.root}/public/CMU Team Event Attendance Export.csv", "wb") do |csv|
			CSV.foreach(cmuTeamEventAttendanceExport.path, headers:false) do |row|
      			csv << row
    		end
		end
	end

	def save_cmuteamcontacthistoryexport_csv_file
		CSV.open("#{Rails.root}/public/CMU Team Contact History Export.csv", "wb") do |csv|
			CSV.foreach(cmuteamcontacthistoryexport_file.path, headers:false) do |row|
      			csv << row
    		end
		end
	end


#############################################################
# import data
#############################################################
	def import_constituent_csv_data
		CSV.foreach("#{Rails.root}/public/constituent.csv", headers:true) do |row|
      		create_constituent(row)
    	end
	end

	def import_uncleanconstituent_csv_data
		CSV.foreach("#{Rails.root}/public/incomplete_invalid_constituents.csv", headers:true) do |row|
      		create_uncleanconstituent(row)
    	end
	end

	def import_contacthistory_csv_data
		CSV.foreach("#{Rails.root}/public/contact_history.csv", headers:true) do |row|
			lookup_check = row[0].to_s
			if UncleanConstituent.where(:lookup_id => lookup_check).empty?
				create_contacthistory(row)
			else
				create_uncleancontacthistory(row)
				
			end
    	end
	end

	def import_uncleanaddress_csv_data
		CSV.foreach("#{Rails.root}/public/incomplete_invalid_address.csv", headers:true) do |row|
      		create_uncleanaddress(row)
    	end
	end

	def import_address_csv_data
		CSV.foreach("#{Rails.root}/public/address.csv", headers:true) do |row|
      		create_address(row)
    	end
	end

	def import_membershiprecord_csv_data
		CSV.foreach("#{Rails.root}/public/membership_records.csv", headers:true) do |row|
      		lookup_check = row[1].to_s
			if UncleanConstituent.where(:lookup_id => lookup_check).empty?
				create_membershiprecord(row)

			else
				create_uncleanmembershiprecord(row)
			end
    	end
	end

	def import_constituentmembershiprecord_csv_data
		CSV.foreach("#{Rails.root}/public/constituent_membership_records.csv", headers:true) do |row|
      		lookup_check = row[0].to_s
			if UncleanConstituent.where(:lookup_id => lookup_check).empty?
				create_constituentmembershiprecord(row)
			else
				# move membership record to unclean
				create_uncleanconstituentmembershiprecord(row)
			end

    	end
	end


	def import_event_csv_data
		CSV.foreach("#{Rails.root}/public/events.csv", headers:true) do |row|
      		create_event(row)
    	end
	end

	def import_constituentevent_csv_data
		CSV.foreach("#{Rails.root}/public/constituent_events.csv", headers:true) do |row|
      		lookup_check = row[0].to_s
			if UncleanConstituent.where(:lookup_id => lookup_check).empty?
				create_constituentevent(row)
			else
				create_uncleanconstituentevent(row)
			end
    	end
	end

	def import_donationprogram_csv_data
		CSV.foreach("#{Rails.root}/public/donation_program.csv", headers:true) do |row|
      		create_donationprogram(row)
    	end
	end

	def import_donationhistory_csv_data
		CSV.foreach("#{Rails.root}/public/donation_history.csv", headers:true) do |row|
      		lookup_check = row[2].to_s
			if UncleanConstituent.where(:lookup_id => lookup_check).empty?
				create_donationhistory(row)
			else
				create_uncleandonationhistory(row)
			end
    	end
	end

	

	



	private
#############################################################
# create record
#############################################################
	def create_constituent(data)
		Constituent.create! data.to_hash
	end

	def create_address(data)
		Address.create! data.to_hash
	end

	def create_contacthistory(data)
		ContactHistory.create! data.to_hash
	end

	def create_event(data)
		Event.create! data.to_hash
	end

	def create_constituentevent(data)
		ConstituentEvent.create! data.to_hash
	end

	def create_membershiprecord(data)
		MembershipRecord.create! data.to_hash
	end

	def create_constituentmembershiprecord(data)
		ConstituentMembershipRecord.create! data.to_hash
	end

	def create_donationprogram(data)
		DonationProgram.create! data.to_hash
	end

	def create_donationhistory(data)
		data[3]=data[3].to_f
		DonationHistory.create! data.to_hash
	end

	def create_uncleanconstituent(data)
		UncleanConstituent.create! data.to_hash
	end

	def create_uncleanaddress(data)
		UncleanAddress.create! data.to_hash
	end

	def create_uncleancontacthistory(data)
		UncleanContactHistory.create! data.to_hash
	end

	def create_uncleanevent(data)
		UncleanEvent.create! data.to_hash
	end

	def create_uncleanconstituentevent(data)
		UncleanConstituentEvent.create! data.to_hash
	end

	def create_uncleanmembershiprecord(data)
		UncleanMembershipRecord.create! data.to_hash
	end

	def create_uncleanconstituentmembershiprecord(data)
		UncleanConstituentMembershipRecord.create! data.to_hash
	end

	def create_uncleandonationprogram(data)
		UncleanDonationProgram.create! data.to_hash
	end

	def create_uncleandonationhistory(data)
		UncleanDonationHistory.create! data.to_hash
	end


end
