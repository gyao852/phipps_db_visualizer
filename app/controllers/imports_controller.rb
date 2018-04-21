class ImportsController < ApplicationController
	def importfile
      
    	if params[:constituentsfile].nil? || params[:addressesfile].nil?
        `python public/test.py`
      	redirect_to import_page_path, notice: "Please upload a csv file."
    	else
      		importer = Import.new(params[:constituentsfile],params[:addressesfile])
      		if File.exist?("#{Rails.root}/public/cmuTeamconstituentsExport.csv") 
            File.delete("#{Rails.root}/public/cmuTeamconstituentsExport.csv")
          end
          if File.exist?("#{Rails.root}/public/cmuTeamDonationsExport.csv") 
            File.delete("#{Rails.root}/public/cmuTeamDonationsExport.csv")
          end
          if File.exist?("#{Rails.root}/public/cmuTeamEventAttendanceExport.csv") 
            File.delete("#{Rails.root}/public/cmuTeamEventAttendanceExport.csv")
          end
          if File.exist?("#{Rails.root}/public/cmuTeamContactHistoryExport.csv") 
            File.delete("#{Rails.root}/public/cmuTeamContactHistoryExport.csv")
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
      		importer.save_constituents_csv_file
          importer.save_addresses_csv_file
          # importer.save_cmuTeamconstituentsExport_csv_file
          # importer.save_cmuTeamDonationsExport_csv_file
          # importer.save_cmuTeamEventAttendanceExport_csv_file
          # importer.save_cmuTeamContactHistoryExport_csv_file
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

      constituentsfile = File.new(open("#{Rails.root}/public/constituentsfile.csv"))
      addressesfile = File.new(open("#{Rails.root}/public/addressesfile.csv"))
      # membershiprecordfile = File.new(open("#{Rails.root}/public/membershiprecordfile.csv"))
      # constituentmembershipfile = File.new(open("#{Rails.root}/public/constituentmembershipfile.csv"))
      # contacthistoryfile = File.new(open("#{Rails.root}/public/contacthistoryfile.csv"))
      # eventfile = File.new(open("#{Rails.root}/public/eventfile.csv"))
      # constituenteventfile = File.new(open("#{Rails.root}/public/constituenteventfile.csv"))
      # donationhistoryfile = File.new(open("#{Rails.root}/public/donationhistoryfile.csv"))
      # donationprogramfile = File.new(open("#{Rails.root}/public/donationprogramfile.csv"))

      # uncleanconstituentsfile = File.new(open("#{Rails.root}/public/uncleanconstituentsfile.csv"))
      # uncleanaddressesfile = File.new(open("#{Rails.root}/public/uncleanaddressesfile.csv"))
      # uncleanmembershiprecordfile = File.new(open("#{Rails.root}/public/uncleanmembershiprecordfile.csv"))
      # uncleanconstituentmembershipfile = File.new(open("#{Rails.root}/public/uncleanconstituentmembershipfile.csv"))
      # uncleancontacthistoryfile = File.new(open("#{Rails.root}/public/uncleancontacthistoryfile.csv"))
      # uncleaneventfile = File.new(open("#{Rails.root}/public/uncleaneventfile.csv"))
      # uncleanconstituenteventfile = File.new(open("#{Rails.root}/public/uncleanconstituenteventfile.csv"))
      # uncleandonationhistoryfile = File.new(open("#{Rails.root}/public/uncleandonationhistoryfile.csv"))
      # uncleandonationprogramfile = File.new(open("#{Rails.root}/public/uncleandonationprogramfile.csv"))
    
  		importer = Import.new()
  		importer.import_constituent_csv_data
      importer.import_address_csv_data
  		redirect_to import_page_path, notice: "Constituents Added Successfully through CSV"
	end
end
