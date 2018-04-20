class ImportsController < ApplicationController
	def importfile
    	if params[:file].nil?
      		redirect_to import_page_path, notice: "Please upload a csv file."
    	else
      		importer = Import.new(params[:file])
      		if File.exist?("#{Rails.root}/public/constituentsfile.csv") 
      			File.delete("#{Rails.root}/public/constituentsfile.csv")
      		end
      		importer.save_constituents_csv_file
          redirect_to import_page_path, notice: "Constituents Added Successfully through CSV"
    	end
  	end

	def importdata
  		Constituent.delete_all
      file = File.new(open("#{Rails.root}/public/constituentsfile.csv"))
      puts file
  		importer = Import.new(file)
  		importer.import_constituent_csv_data
  		redirect_to import_page_path, notice: "Constituents Added Successfully through CSV"
	end
end
