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
          MovingWorker.perform_async(params[:cmuteamconstituentsexport].path,
            params[:cmuteameventattendanceexport].path,
            params[:cmuteamcommunicationhistoryexport].path,
            params[:cmuteamdonationexport].path)
          redirect_to import_page_path, notice: "Constituents Added Successfully through CSV"
    	end
  	end

	def importdata
      UploadWorker.perform_async()


  		redirect_to constituents_path, notice: "Constituents Added Successfully through CSV"
	end
end
