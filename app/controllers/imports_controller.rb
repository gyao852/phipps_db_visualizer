class ImportsController < ApplicationController

def importfile
    if params[:file].nil?
      redirect_to constituents_path, notice: "Please upload a csv file."
    else
      Constituent.delete_all
      importer = Importer.new(params[:file])
      importer.import_constituent_csv_data
      redirect_to constituents_path, notice: "Constituents Added Successfully through CSV"
    end
  end
	
end
