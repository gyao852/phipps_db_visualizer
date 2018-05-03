class ImportsController < ApplicationController
  before_action :check_login
	def importfile

    	if params[:cmuteameventattendanceexport].nil? || params[:cmuteamdonationexport].nil? || params[:cmuteamconstituentsexport].nil? || params[:cmuteamcommunicationhistoryexport].nil?
        CleanWorker.perform_async()

        #`python public/cleaning_script.py`
      	redirect_to import_page_path, notice: "Please upload a csv file."
    	else

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
          MovingWorker.perform_async(params[:cmuteamconstituentsexport].path,
            params[:cmuteameventattendanceexport].path,
            params[:cmuteamcommunicationhistoryexport].path,
            params[:cmuteamdonationexport].path)


          # importer = Import.new(params[:cmuteamconstituentsexport],
          #   params[:cmuteameventattendanceexport],
          #   params[:cmuteamcommunicationhistoryexport],
          #   params[:cmuteamdonationexport])
          #
          # importer.save_cmuteamconstituentsexport_csv_file
          # importer.save_cmuteamdonationsexport_csv_file
          # importer.save_cmuteamcontacthistoryexport_csv_file
          # importer.save_cmuteameventattendanceexport_csv_file
          redirect_to import_page_path, notice: "Constituents Added Successfully through CSV"
    	end
  	end

	def importdata
      UploadWorker.perform_async()
  		redirect_to constituents_path, notice: "Constituents Added Successfully through CSV"
	end
end
