class Import < ApplicationRecord
	@unclean_constituent_lookup_id = UncleanConstituent.pluck(:lookup_id)
	@constituent_lookup_id = Constituent.pluck(:lookup_id)
	@clean_membership = MembershipRecord.pluck(:membership_id)
	@unclean_membership = UncleanMembershipRecord.pluck(:membership_id)


	attr_accessor :cmuteamconstituentsexport_file
	attr_accessor :cmuteameventattendanceexport_file
	attr_accessor :cmuteamcontacthistoryexport_file
	attr_accessor :cmuteamdonationsexport_file
	def initialize(cmuteamconstituentsexport_file=nil,cmuteameventattendanceexport_file=nil,cmuteamcontacthistoryexport_file=nil,cmuteamdonationsexport_file=nil)
		@cmuteamconstituentsexport_file = cmuteamconstituentsexport_file
		@cmuteameventattendanceexport_file = cmuteameventattendanceexport_file
		@cmuteamcontacthistoryexport_file = cmuteamcontacthistoryexport_file
		@cmuteamdonationsexport_file = cmuteamdonationsexport_file
	end

#############################################################
# upload files
#############################################################



def save_cmuteamconstituentsexport_csv_file
	CSV.open("#{Rails.root}/public/CMU Team Constituents Export.csv", "wb") do |csv|
		CSV.foreach(cmuteamconstituentsexport_file, headers: false,
			encoding: "bom|utf-8") do |row|
					csv << row
			end
	end
end




	def save_cmuteameventattendanceexport_csv_file
		CSV.open("#{Rails.root}/public/CMU Team Event Attendance Export.csv", "wb") do |csv|
			CSV.foreach(cmuteameventattendanceexport_file, headers:false,
				encoding: "bom|utf-8") do |row|
      			csv << row
    		end
		end
	end


	def save_cmuteamdonationsexport_csv_file
		CSV.open("#{Rails.root}/public/CMU Team Donations Export.csv", "wb") do |csv|
			CSV.foreach(cmuteamdonationsexport_file, headers:false,
				encoding: "bom|utf-8") do |row|
      			csv << row
    		end
		end
	end


	def save_cmuteamcontacthistoryexport_csv_file
		CSV.open("#{Rails.root}/public/CMU Team Contact History Export.csv", "wb") do |csv|
			CSV.foreach(cmuteamcontacthistoryexport_file, headers:false,
				encoding: "bom|utf-8") do |row|
      			csv << row
    		end
		end
	end


#############################################################
# import data
#############################################################
	def import_constituent_csv_data
		CSV.foreach("#{Rails.root}/public/constituent.csv", headers:true) do |row|
					if (row[8]==nil)
						row[8] = false
					end
      		create_constituent(row)
    	end
		@constituent_lookup_id = Constituent.pluck(:lookup_id)
	end

	def import_uncleanconstituent_csv_data
		CSV.foreach("#{Rails.root}/public/incomplete_invalid_constituent.csv", headers:true) do |row|
					if (row[9]==nil)
						row[9] = false
					end
					if (row[12]==nil)
						row[12] = false
					end
					if (row[13]==nil)
						row[13] = false
					end
					if (row[14]==nil)
						row[14] = false
					end
					if (row[15]==nil)
						row[15] = false
					end
					if (row[16]==nil)
						row[16] = {}
					else
						row[16] = row[16].split(".")
					end
					create_uncleanconstituent(row)
    	end
    	@unclean_constituent_lookup_id = UncleanConstituent.pluck(:lookup_id)
	end

	def import_contacthistory_csv_data
		CSV.foreach("#{Rails.root}/public/contact_history.csv", headers:true) do |row|
			lookup_check = row[0].to_s
			if @unclean_constituent_lookup_id.include?(lookup_check)
				create_uncleancontacthistory(row)
			elsif @constituent_lookup_id.include?(lookup_check)
				create_contacthistory(row)
			end
    	end
	end

	def import_uncleanaddress_csv_data
		CSV.foreach("#{Rails.root}/public/incomplete_invalid_address.csv", headers:true) do |row|
			if (row[12]==nil)
				row[12] = false
			end
			if (row[13]==nil)
				row[13] = false
			end
			if (row[14]==nil)
				row[14] = false
			end
			if (row[15]==nil)
				row[15] = false
			end
			if (row[16]==nil)
				row[16] = false
			end
					create_uncleanaddress(row)
    	end
	end

	def import_address_csv_data
		CSV.foreach("#{Rails.root}/public/address.csv", headers:true) do |row|
      		create_address(row)
    	end
	end

	def import_membershiprecord_csv_data
		CSV.foreach("#{Rails.root}/public/membership_record.csv", headers:true) do |row|
      		lookup_check = row[0].to_s
			if @unclean_constituent_lookup_id.include?(lookup_check)
				create_uncleanmembershiprecord(row)
			else
				create_membershiprecord(row)
			end
    	end
	end

	def import_constituentmembershiprecord_csv_data
		@clean_membership = MembershipRecord.pluck(:membership_id)
		@unclean_membership = UncleanMembershipRecord.pluck(:membership_id)
		CSV.foreach("#{Rails.root}/public/constituent_membership_record.csv", headers:true) do |row|
      		lookup_check = row[0].to_s
      		membership_check = row[1].to_s
			if @unclean_constituent_lookup_id.include?(lookup_check) and @unclean_membership.include?(membership_check)
				create_uncleanconstituentmembershiprecord(row)
			elsif @constituent_lookup_id.include?(lookup_check)and @clean_membership.include?(membership_check)
				create_constituentmembershiprecord(row)
			end

    	end
	end


	def import_event_csv_data
		CSV.foreach("#{Rails.root}/public/event.csv", headers:true) do |row|
      		create_event(row)
      		create_uncleanevent(row)
    	end
	end

	def import_constituentevent_csv_data
		CSV.foreach("#{Rails.root}/public/constituent_event.csv", headers:true) do |row|
      		lookup_check = row[0].to_s
			if @unclean_constituent_lookup_id.include?(lookup_check)
				if (row[3]==nil)
					row[3] = false
				end
				create_uncleanconstituentevent(row)
			else
				if (row[3]==nil)
					row[3] = false
				end
				create_constituentevent(row)
			end
    	end
	end

	def import_donationprogram_csv_data
		CSV.foreach("#{Rails.root}/public/donation_program.csv", headers:true) do |row|
					if (row[6]==nil)
						row[6] = false
					end
					if (row[7]==nil)
						row[7] = false
					end
      		create_donationprogram(row)
      		create_uncleandonationprogram(row)
    	end
	end

	def import_donationhistory_csv_data
		CSV.foreach("#{Rails.root}/public/donation_history.csv", headers:true) do |row|
      		lookup_check = row[2].to_s
			if @unclean_constituent_lookup_id.include?(lookup_check)
				if (row[6]==nil)
					row[6] = false
				end
				if (row[7]==nil)
					row[7] = false
				end
				create_uncleandonationhistory(row)
			elsif @constituent_lookup_id.include?(lookup_check)
				create_donationhistory(row)
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
