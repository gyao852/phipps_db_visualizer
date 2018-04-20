class Import < ApplicationRecord

	attr_accessor :constituents_file
	attr_accessor :addresses_file

	def initialize(constituents_file,addresses_file)
		@constituents_file = constituents_file
		@addresses_file = addresses_file
	end

	def save_constituents_csv_file
		CSV.open("#{Rails.root}/public/constituentsfile.csv", "wb") do |csv|
			CSV.foreach(constituents_file.path, headers:false) do |row|
      			csv << row
    		end
		end
	end

	def save_addresses_csv_file
		CSV.open("#{Rails.root}/public/addressesfile.csv", "wb") do |csv|
			CSV.foreach(addresses_file.path, headers:false) do |row|
      			csv << row
    		end
		end
	end

	def import_constituent_csv_data
		CSV.foreach(constituents_file, headers:true) do |row|
      		create_constituent(row)
    	end
	end

	def import_address_csv_data
		CSV.foreach(addresses_file, headers:true) do |row|
      		create_address(row)
    	end
	end

	private

	def create_constituent(data)
		Constituent.create! data.to_hash
	end

	def create_address(data)
		Address.create! data.to_hash
	end
end
