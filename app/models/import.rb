class Import < ApplicationRecord










	def import_constituent_csv_data
		CSV.foreach(file.path, headers:true) do |row|
      		create_constituent(row)
    	end
	end


	private
	def create_constituent(data)
		Constituent.create! data.to_hash
	end
end
