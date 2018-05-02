class UploadWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform()
    puts "Sidekiq is deleting old database."
    #Constituent.delete_all
    UncleanConstituent.delete_all
    UncleanAddress.delete_all
    #DonationProgram.delete_all
    #Event.delete_all
    #Address.delete_all
    #ContactHistory.delete_all
    #ConstituentEvent.delete_all
    #DonationHistory.delete_all
    #UncleanDonationProgram.delete_all
    #UncleanEvent.delete_all
    #UncleanContactHistory.delete_all
    #UncleanConstituentMembershipRecord.delete_all
    #UncleanMembershipRecord.delete_all
    #UncleanConstituentEvent.delete_all
    #UncleanDonationHistory.delete_all
    #ConstituentMembershipRecord.delete_all
    #MembershipRecord.delete_all
    puts "Sidekiq is finished deleting old database."
    puts "Sidekiq is uploading to Rails Postgres Database."
    importer = Import.new()
    #importer.import_constituent_csv_data
    importer.import_uncleanconstituent_csv_data
    #importer.import_address_csv_data
    #importer.import_contacthistory_csv_data
    #importer.import_event_csv_data
    #importer.import_constituentevent_csv_data
    importer.import_uncleanaddress_csv_data
    #importer.import_donationprogram_csv_data
    #importer.import_donationhistory_csv_data
    #importer.import_membershiprecord_csv_data
    #importer.import_constituentmembershiprecord_csv_data
    puts "Sidekiq is finished uploading to Rails Postgres Database"
  end

end
