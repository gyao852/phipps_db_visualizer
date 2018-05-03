class ImportsController < ApplicationController
  before_action :check_login
	def importfile

    	if params[:cmuteameventattendanceexport].nil? || params[:cmuteamdonationexport].nil? || params[:cmuteamconstituentsexport].nil? || params[:cmuteamcommunicationhistoryexport].nil?
      	redirect_to import_page_path
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
<<<<<<< HEAD
          if File.exist?("#{Rails.root}/public/constituentsfile.csv")
      			File.delete("#{Rails.root}/public/constituentsfile.csv")
      		end
          if File.exist?("#{Rails.root}/public/addressesfile.csv")
            File.delete("#{Rails.root}/public/addressesfile.csv")
          end

          ImportWorker.perform_async(params[:cmuteamconstituentsexport].path,
            params[:cmuteameventattendanceexport].path,
            params[:cmuteamcommunicationhistoryexport].path,
            params[:cmuteamdonationexport].path)
          flash[:success] = "Cleaning the imported data. This will take a few minutes."
          redirect_to import_page_path
=======
          MovingWorker.perform_async(params[:cmuteamconstituentsexport].path,
            params[:cmuteameventattendanceexport].path,
            params[:cmuteamcommunicationhistoryexport].path,
            params[:cmuteamdonationexport].path)
          redirect_to import_page_path, notice: "Constituents Added Successfully through CSV"
>>>>>>> master
    	end
  end

	def importdata
      UploadWorker.perform_async()
      flash[:success] = "Updating database with new clean data! This will take some time..."
  		redirect_to import_page_path
    end
end
