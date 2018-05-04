class ImportsController < ApplicationController
  before_action :check_login
	def importfile

    	if params[:cmuteameventattendanceexport].nil? || params[:cmuteamdonationexport].nil? || params[:cmuteamconstituentsexport].nil? || params[:cmuteamcommunicationhistoryexport].nil?
          # `python public/cleaning_script.py`
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

          ImportWorker.perform_async(params[:cmuteamconstituentsexport].path,
            params[:cmuteameventattendanceexport].path,
            params[:cmuteamcommunicationhistoryexport].path,
            params[:cmuteamdonationexport].path)
          # importer = Import.new(params[:cmuteamconstituentsexport].path,
          #   params[:cmuteameventattendanceexport].path,
          #   params[:cmuteamcommunicationhistoryexport].path,
          #   params[:cmuteamdonationexport].path)
          # # added .path here isntead of import model
          # importer.save_cmuteamconstituentsexport_csv_file
          # importer.save_cmuteamdonationsexport_csv_file
          # importer.save_cmuteamcontacthistoryexport_csv_file
          # importer.save_cmuteameventattendanceexport_csv_file
            flash[:success] = "Cleaning the imported data. This will take a few minutes."
          redirect_to import_page_path
    	end
  	end

	def importdata
      flash[:success] = "Updating database with new clean data! This will take some time..."
      UploadWorker.perform_async()
  		redirect_to import_page_path
	end
end
