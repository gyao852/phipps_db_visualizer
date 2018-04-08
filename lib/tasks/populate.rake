namespace :db do
    desc "Erase and fill database"

    # creating a rake task within db namespace called 'populate'
    # executing 'rake db:populate' will cause this script to run
    task :populate => :environment do
        # Need two gems to make this work: faker & populator
        # Docs at: http://populator.rubyforge.org/
        require 'populator'
        # Docs at: http://faker.rubyforge.org/rdoc/
        require 'faker'

        # Step 1: clear any old data in the db
        [Constituent, ConstituentMembershipRecord, MembershipRecord, ConstituentEvent, Event, DonationProgram, 
        DonationHistory, User, ContactHistory, Event, Address].each(&:delete_all)

        # Step 2: add some constituents to work with
        
    end
end