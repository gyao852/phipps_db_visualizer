class ImportsController < ApplicationController
	def importfile
    
    	if params[:constituentsfile].nil? || params[:addressesfile].nil?
      	redirect_to import_page_path, notice: "Please upload a csv file."
    	else
      		importer = Import.new(params[:constituentsfile],params[:addressesfile])
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
  		importer = Import.new(constituentsfile,addressesfile)
  		importer.import_constituent_csv_data
      importer.import_address_csv_data
  		redirect_to import_page_path, notice: "Constituents Added Successfully through CSV"
	end
end
