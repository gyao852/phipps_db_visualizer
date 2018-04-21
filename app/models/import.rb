class Import < ApplicationRecord

	attr_accessor :constituents_file
	attr_accessor :addresses_file
	# attr_accessor :cmuTeamconstituentsExport
	# attr_accessor :cmuTeamEventAttendanceExport
	# attr_accessor :cmuTeamContactHistoryExport
	# attr_accessor :cmuTeamDonationProgramExport
	# attr_accessor :cmuTeamDonationsExport
	# attr_accessor :cmuTeamEventExport

	def initialize(constituents_file=nil,addresses_file=nil)
		@constituents_file = constituents_file
		@addresses_file = addresses_file
		# @cmuTeamconstituentsExport = cmuTeamconstituentsExport
		# @cmuTeamEventAttendanceExport = cmuTeamEventAttendanceExport
		# @cmuTeamContactHistoryExport = cmuTeamContactHistoryExport
		# @cmuTeamDonationProgramExport = cmuTeamDonationProgramExport
		# @cmuTeamDonationsExport = cmuTeamDonationsExport
		# @cmuTeamEventExport = cmuTeamEventExport
	end

#############################################################
# upload files 
#############################################################

	def save_constituents_csv_file
		CSV.open("#{Rails.root}/public/constituentsfile.csv", "wb") do |csv|
			CSV.foreach(constituents_file.path, headers:false) do |row|
      			csv << row
    		end
		end
	end

	def save_addresses_csv_file
		CSV.open("#{Rails.root}/public/addressesfile.csv", "wb") do |csv|
			CSV.foreach(addresses_file.path, headers:false) do |row|
      			csv << row
    		end
		end
	end

	def save_CMUTeamconstituentsExport_csv_file
		CSV.open("#{Rails.root}/public/cmuTeamconstituentsExport.csv", "wb") do |csv|
			CSV.foreach(cmuTeamconstituentsExport.path, headers:false) do |row|
      			csv << row
    		end
		end
	end

	def save_CMUTeamDonationsExport_csv_file
		CSV.open("#{Rails.root}/public/cmuTeamDonationsExport.csv", "wb") do |csv|
			CSV.foreach(cmuTeamDonationsExport.path, headers:false) do |row|
      			csv << row
    		end
		end
	end

	def save_CMUTeamEventAttendanceExport_csv_file
		CSV.open("#{Rails.root}/public/cmuTeamEventAttendanceExport.csv", "wb") do |csv|
			CSV.foreach(cmuTeamEventAttendanceExport.path, headers:false) do |row|
      			csv << row
    		end
		end
	end

	def save_CMUTeamContactHistoryExport_csv_file
		CSV.open("#{Rails.root}/public/cmuTeamContactHistoryExport.csv", "wb") do |csv|
			CSV.foreach(cmuTeamContactHistoryExport.path, headers:false) do |row|
      			csv << row
    		end
		end
	end

	def save_CMUTeamEventExport_csv_file
		CSV.open("#{Rails.root}/public/cmuTeamEventExport.csv", "wb") do |csv|
			CSV.foreach(cmuTeamEventExport.path, headers:false) do |row|
      			csv << row
    		end
		end
	end

	def save_CMUTeamDonationProgramExport_csv_file
		CSV.open("#{Rails.root}/public/cmuTeamDonationProgramExport.csv", "wb") do |csv|
			CSV.foreach(cmuTeamDonationProgramExport.path, headers:false) do |row|
      			csv << row
    		end
		end
	end
#############################################################
# import data
#############################################################
	def import_constituent_csv_data
		CSV.foreach("#{Rails.root}/public/constituentsfile.csv", headers:true) do |row|
      		create_constituent(row)
    	end
	end

	def import_address_csv_data
		CSV.foreach("#{Rails.root}/public/addressesfile.csv", headers:true) do |row|
      		create_address(row)
    	end
	end

	def import_membershiprecord_csv_data
		CSV.foreach("#{Rails.root}/public/membershiprecordfile.csv", headers:true) do |row|
      		create_membershiprecord(row)
    	end
	end

	def import_constituentmembershiprecord_csv_data
		CSV.foreach("#{Rails.root}/public/constituentmembershipfile.csv", headers:true) do |row|
      		create_constituentmembershiprecord(row)
    	end
	end

	def import_contacthistory_csv_data
		CSV.foreach("#{Rails.root}/public/contacthistoryfile.csv", headers:true) do |row|
      		create_contacthistory(row)
    	end
	end

	def import_event_csv_data
		CSV.foreach("#{Rails.root}/public/eventfile.csv", headers:true) do |row|
      		create_event(row)
    	end
	end

	def import_constituentevent_csv_data
		CSV.foreach("#{Rails.root}/public/constituenteventfile.csv", headers:true) do |row|
      		create_constituentevent(row)
    	end
	end

	def import_donationprogram_csv_data
		CSV.foreach("#{Rails.root}/public/donationprogramfile.csv", headers:true) do |row|
      		create_donationprogram(row)
    	end
	end

	def import_donationhistory_csv_data
		CSV.foreach("#{Rails.root}/public/donationhistoryfile.csv", headers:true) do |row|
      		create_donationhistory(row)
    	end
	end

	def import_uncleanconstituent_csv_data
		CSV.foreach("#{Rails.root}/public/uncleanconstituentsfile.csv", headers:true) do |row|
      		create_uncleanconstituentconstituent(row)
    	end
	end

	def import_uncleanaddress_csv_data
		CSV.foreach("#{Rails.root}/public/uncleanaddressesfile.csv", headers:true) do |row|
      		create_uncleanaddress(row)
    	end
	end

	def import_uncleanmembershiprecord_csv_data
		CSV.foreach("#{Rails.root}/public/uncleanmembershiprecordfile.csv", headers:true) do |row|
      		create_uncleanmembershiprecord(row)
    	end
	end

	def import_uncleanconstituentmembership_csv_data
		CSV.foreach("#{Rails.root}/public/uncleanconstituentmembershipfile.csv", headers:true) do |row|
      		create_uncleanconstituentmembership(row)
    	end
	end

	def import_uncleancontacthistory_csv_data
		CSV.foreach("#{Rails.root}/public/uncleancontacthistoryfile.csv", headers:true) do |row|
      		create_uncleancontacthistory(row)
    	end
	end

	def import_uncleanevent_csv_data
		CSV.foreach("#{Rails.root}/public/uncleaneventfile.csv", headers:true) do |row|
      		create_uncleanevent(row)
    	end
	end

	def import_uncleanconstituentevent_csv_data
		CSV.foreach("#{Rails.root}/public/uncleanconstituenteventfile.csv", headers:true) do |row|
      		create_uncleanconstituentevent(row)
    	end
	end

	def import_uncleandonationprogram_csv_data
		CSV.foreach("#{Rails.root}/public/uncleandonationprogramfile.csv", headers:true) do |row|
      		create_uncleandonationprogram(row)
    	end
	end

	def import_uncleandonationhistory_csv_data
		CSV.foreach("#{Rails.root}/public/uncleandonationhistoryfile.csv", headers:true) do |row|
      		create_uncleandonationhistory(row)
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
