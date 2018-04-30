class ImportsController < ApplicationController
  before_action :check_login
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

          redirect_to import_page_path, notice: "Constituents Added Successfully through CSV"
    	end
  	end

	def importdata
      # Constituent.delete_all
      # UncleanConstituent.delete_all
      # UncleanAddress.delete_all
      # DonationProgram.delete_all
      # Event.delete_all
      # Address.delete_all
      # ContactHistory.delete_all
      # ConstituentEvent.delete_all
      # DonationHistory.delete_all
      # UncleanDonationProgram.delete_all
      # UncleanEvent.delete_all
      # UncleanContactHistory.delete_all
      # UncleanConstituentMembershipRecord.delete_all
      # UncleanMembershipRecord.delete_all
      # UncleanConstituentEvent.delete_all
      # UncleanDonationHistory.delete_all
      # ConstituentMembershipRecord.delete_all
      # MembershipRecord.delete_all

  		importer = Import.new()
      # tested
  		# importer.import_constituent_csv_data
    #   importer.import_uncleanconstituent_csv_data
    #   importer.import_address_csv_data
    #   importer.import_contacthistory_csv_data
    #   importer.import_event_csv_data
    #   importer.import_constituentevent_csv_data
    #   importer.import_uncleanaddress_csv_data
    #   importer.import_donationprogram_csv_data 
    #   importer.import_donationhistory_csv_data
    #   importer.import_membershiprecord_csv_data
    #   importer.import_constituentmembershiprecord_csv_data


      # # To debug import
      # address line 1 is emplty for some records
      # missing constituent  8-10155266 from constituent report
      # missing constituent  8-10155266 from constituent report
      #



  		redirect_to constituents_path, notice: "Constituents Added Successfully through CSV"
	end
end
