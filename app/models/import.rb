class Import < ApplicationRecord

	attr_accessor :file

	def initialize(file)
		@file = file
	end

	def save_constituents_csv_file
		CSV.open("#{Rails.root}/public/constituents_file.csv", "wb") do |csv|
			CSV.foreach(file.path, headers:false) do |row|
      			csv << row
    		end
		end
	end

	def import_constituent_csv_data
		CSV.foreach(file, headers:true) do |row|
      		create_constituent(row)
    	end
	end

	private
	def create_constituent(data)
		Constituent.create! data.to_hash
	end
end
