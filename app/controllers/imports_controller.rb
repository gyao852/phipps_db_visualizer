class ImportsController < ApplicationController
	def importfile
      
    	if params[:constituentsfile].nil? || params[:addressesfile].nil?
        `python public/test.py`
      	redirect_to import_page_path, notice: "Please upload a csv file."
    	else
      		importer = Import.new(params[:constituentsfile],params[:addressesfile])
      		if File.exist?("#{Rails.root}/public/CMUTeamconstituentsExport.csv") 
            File.delete("#{Rails.root}/public/CMUTeamconstituentsExport.csv")
          end
          if File.exist?("#{Rails.root}/public/CMUTeamDonationsExport.csv") 
            File.delete("#{Rails.root}/public/CMUTeamDonationsExport.csv")
          end
          if File.exist?("#{Rails.root}/public/CMUTeamEventAttendanceExport.csv") 
            File.delete("#{Rails.root}/public/CMUTeamEventAttendanceExport.csv")
          end
          if File.exist?("#{Rails.root}/public/CMUTeamContactHistoryExport.csv") 
            File.delete("#{Rails.root}/public/CMUTeamContactHistoryExport.csv")
          end
          if File.exist?("#{Rails.root}/public/CMUTeamEventExport.csv") 
            File.delete("#{Rails.root}/public/CMUTeamEventExport.csv")
          end
          if File.exist?("#{Rails.root}/public/CMUTeamDonationProgramExport.csv") 
            File.delete("#{Rails.root}/public/CMUTeamDonationProgramExport.csv")
          end
          if File.exist?("#{Rails.root}/public/constituentsfile.csv") 
      			File.delete("#{Rails.root}/public/constituentsfile.csv")
      		end
          if File.exist?("#{Rails.root}/public/addressesfile.csv") 
            File.delete("#{Rails.root}/public/addressesfile.csv")
          end
      		importer.save_constituents_csv_file
          importer.save_addresses_csv_file
          redirect_to import_page_path, notice: "Constituents Added Successfully through CSV"
    	end
  	end

	def importdata
  		Constituent.delete_all
      Address.delete_all

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
    
  		importer = Import.new(constituentsfile,addressesfile)
  		importer.import_constituent_csv_data
      importer.import_address_csv_data
  		redirect_to import_page_path, notice: "Constituents Added Successfully through CSV"
	end
end
