class UncleanAddress < ApplicationRecord
    belongs_to :unclean_constituent, :foreign_key => :lookup_id

    scope :invalid_zip_scope, -> {where(invalid_zips: true)}  
    scope :invalid_state_scope, -> {where(invalid_states: true)}
    scope :invalid_address_1_scope, -> {where(invalid_addresses_1: true)}
    scope :invalid_city_scope, ->{where(invalid_cities: true)}
    scope :invalid_country_scope, -> {where(invalid_countries: true)}

     def self.generate_invalid_zips
    	filename = 'reports/invalid-zip-address-report-'+DateTime.current.strftime("%m%d%Y%H%M%S")+'.csv'
    	iz = UncleanAddress.invalid_zip_scope
    	CSV.open(filename, 'wb') do |csv|
    		csv << ['Lookup ID', 'Constituent Name','Invalid Zip']
    		toAppend = []
    		iz.each do |row|
                toAppend[0] = row.lookup_id
                toAppend[1] = row.unclean_constituent.name
    			toAppend[2] = row.zip
    			csv << toAppend
    		end
    	end
    end

    def self.generate_invalid_address_1
    	filename = 'reports/invalid-address-1-address-report-'+DateTime.current.strftime("%m%d%Y%H%M%S")+'.csv'
    	is = UncleanAddress.invalid_address_1_scope
    	CSV.open(filename, 'wb') do |csv|
    		csv << ['Lookup ID', 'Constituent Name','Invalid Address_1']
    		toAppend = []
    		is.each do |row|
                toAppend[0] = row.lookup_id
                toAppend[1] = row.unclean_constituent.name
                toAppend[2] = row.address_1
    			csv << toAppend
    		end
    	end
    end


    def self.generate_invalid_states
    	filename = 'reports/invalid-state-address-report-'+DateTime.current.strftime("%m%d%Y%H%M%S")+'.csv'
    	is = UncleanAddress.invalid_state_scope
    	CSV.open(filename, 'wb') do |csv|
    		csv << ['Lookup ID', 'Constituent Name' ,'Invalid State']
    		toAppend = []
    		is.each do |row|
                toAppend[0] = row.lookup_id
                toAppend[1] = row.unclean_constituent.name
                toAppend[2] = row.state
    			csv << toAppend
    		end
    	end
    end

    def self.generate_invalid_cities
        filename = 'reports/invalid-city-address-report-'+DateTime.current.strftime("%m%d%Y%H%M%S")+'.csv'
    	ic = UncleanAddress.invalid_city_scope
    	CSV.open(filename, 'wb') do |csv|
    		csv << ['Lookup ID', 'Constituent Name','Invalid City']
    		toAppend = []
    		ic.each do |row|
                toAppend[0] = row.lookup_id
                toAppend[1] = row.unclean_constituent.name
                toAppend[2] = row.city
    			csv << toAppend
    		end
    	end
    end
    
    def self.generate_invalid_countries
        filename = 'reports/invalid-country-address-report-'+DateTime.current.strftime("%m%d%Y%H%M%S")+'.csv'
    	ic = UncleanAddress.invalid_country_scope
    	CSV.open(filename, 'wb') do |csv|
    		csv << ['Lookup ID', 'Constituent Name','Invalid City']
    		toAppend = []
    		ic.each do |row|
                toAppend[0] = row.lookup_id
                toAppend[1] = row.unclean_constituent.name
                toAppend[2] = row.country
    			csv << toAppend
    		end
    	end
    end

 end
