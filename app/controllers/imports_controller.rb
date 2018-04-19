class ImportsController < ApplicationController
	def importfile
    	if params[:file].nil?
      		redirect_to import_page_path, notice: "Please upload a csv file."
    	else
      		importer = Import.new(params[:file])
      		if File.exist?("#{Rails.root}/public/constituents_file.csv") 
      			File.delete("#{Rails.root}/public/constituents_file.csv")
      		end
      		importer.save_constituents_csv_file
    	end
  	end

	def importdata
  		Constituent.delete_all
  		importer = Import.new(params[])
  		importer.import_constituent_csv_data
  		redirect_to import_page_path, notice: "Constituents Added Successfully through CSV"
	end
end
