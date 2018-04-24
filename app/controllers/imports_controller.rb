class ImportsController < ApplicationController
	def importfile

    	if params[:cmuteameventattendanceexport].nil? || params[:cmuteamdonationexport].nil? || params[:cmuteamconstituentsexport].nil?|| params[:cmuteamcommunicationhistoryexport].nil?
        `python public/cleaning_script.py`
      	redirect_to import_page_path, notice: "Please upload a csv file."
    	else
      		importer = Import.new(params[:cmuteamconstituentsexport],params[:cmuteameventattendanceexport],params[:cmuteamcommunicationhistoryexport],params[:cmuteamdonationexport])
      		if File.exist?("#{Rails.root}/public/CMU Team Constituents Export.csv")
            File.delete("#{Rails.root}/public/CMU Team Constituents Export.csv")
          end
          if File.exist?("#{Rails.root}/public/CMU Team Donations Export.csv")
            File.delete("#{Rails.root}/public/CMU Team Donations Export.csv")
          end
          if File.exist?("#{Rails.root}/public/CMU Team Event Attendance Export.csv")
            File.delete("#{Rails.root}/public/CMU Team Event Attendance Export.csv")
          end
          if File.exist?("#{Rails.root}/public/CMU Team Contact History Export.csv")
            File.delete("#{Rails.root}/public/CMU Team Contact History Export.csv")
          end
          if File.exist?("#{Rails.root}/public/cmuTeamEventExport.csv")
            File.delete("#{Rails.root}/public/cmuTeamEventExport.csv")
          end
          if File.exist?("#{Rails.root}/public/cmuTeamDonationProgramExport.csv")
            File.delete("#{Rails.root}/public/cmuTeamDonationProgramExport.csv")
          end
          if File.exist?("#{Rails.root}/public/constituentsfile.csv")
      			File.delete("#{Rails.root}/public/constituentsfile.csv")
      		end
          if File.exist?("#{Rails.root}/public/addressesfile.csv")
            File.delete("#{Rails.root}/public/addressesfile.csv")
          end
          importer.save_cmuteamconstituentsexport_csv_file
          importer.save_cmuteamdonationsexport_csv_file
          importer.save_cmuteamcontacthistoryexport_csv_file
          importer.save_cmuteameventattendanceexport_csv_file
          # importer.save_cmuTeamEventExport_csv_file
          # importer.save_cmuTeamDonationProgramExport_csv_file
          redirect_to import_page_path, notice: "Constituents Added Successfully through CSV"
    	end
  	end

	def importdata
      Address.delete_all
      ContactHistory.delete_all
      ConstituentMembershipRecord.delete_all
      MembershipRecord.delete_all
      ConstituentEvent.delete_all
      DonationHistory.delete_all
      DonationProgram.delete_all
      Event.delete_all
      Constituent.delete_all

   #    constituentsfile = File.new(open("#{Rails.root}/public/CMU Team Constituents Export.csv"))
			# # TO ASH: There is no address file, address is in the constituents export
			# # addressesfile = File.new(open("#{Rails.root}/public/addressesfile.csv"))
   #    # membershiprecordfile = File.new(open("#{Rails.root}/public/membershiprecordfile.csv"))
   #    # constituentmembershipfile = File.new(open("#{Rails.root}/public/constituentmembershipfile.csv"))
   #    # contacthistoryfile = File.new(open("#{Rails.root}/public/contacthistoryfile.csv"))
   #    # eventfile = File.new(open("#{Rails.root}/public/eventfile.csv"))
   #    # constituenteventfile = File.new(open("#{Rails.root}/public/constituenteventfile.csv"))
   #    # donationhistoryfile = File.new(open("#{Rails.root}/public/donationhistoryfile.csv"))
   #    # donationprogramfile = File.new(open("#{Rails.root}/public/donationprogramfile.csv"))

   #    # uncleanconstituentsfile = File.new(open("#{Rails.root}/public/uncleanconstituentsfile.csv"))
   #    # uncleanaddressesfile = File.new(open("#{Rails.root}/public/uncleanaddressesfile.csv"))
   #    # uncleanmembershiprecordfile = File.new(open("#{Rails.root}/public/uncleanmembershiprecordfile.csv"))
   #    # uncleanconstituentmembershipfile = File.new(open("#{Rails.root}/public/uncleanconstituentmembershipfile.csv"))
   #    # uncleancontacthistoryfile = File.new(open("#{Rails.root}/public/uncleancontacthistoryfile.csv"))
   #    # uncleaneventfile = File.new(open("#{Rails.root}/public/uncleaneventfile.csv"))
   #    # uncleanconstituenteventfile = File.new(open("#{Rails.root}/public/uncleanconstituenteventfile.csv"))
   #    # uncleandonationhistoryfile = File.new(open("#{Rails.root}/public/uncleandonationhistoryfile.csv"))
   #    # uncleandonationprogramfile = File.new(open("#{Rails.root}/public/uncleandonationprogramfile.csv"))

  		importer = Import.new()
  		importer.import_constituent_csv_data
      importer.import_uncleanconstituent_csv_data
      # importer.import_membershiprecord_csv_data
      # importer.import_constituentmembershiprecord_csv_data
      importer.import_uncleanaddress_csv_data
      importer.import_event_csv_data
      importer.import_donationprogram_csv_data
      importer.import_contacthistory_csv_data
      importer.import_address_csv_data
      importer.import_constituentevent_csv_data
      importer.import_constituentevent_csv_data
      importer.import_donationhistory_csv_data
  		redirect_to import_page_path, notice: "Constituents Added Successfully through CSV"
	end
end
