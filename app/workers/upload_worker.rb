class UploadWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform()


    # Drop old postgres database
    puts "Sidekiq is deleting the old database."
    Constituent.delete_all
    UncleanConstituent.delete_all
    UncleanAddress.delete_all
    DonationProgram.delete_all
    Event.delete_all
    Address.delete_all
    ContactHistory.delete_all
    ConstituentEvent.delete_all
    DonationHistory.delete_all
    UncleanDonationProgram.delete_all
    UncleanEvent.delete_all
    UncleanContactHistory.delete_all
    UncleanConstituentMembershipRecord.delete_all
    UncleanMembershipRecord.delete_all
    UncleanConstituentEvent.delete_all
    UncleanDonationHistory.delete_all
    ConstituentMembershipRecord.delete_all
    MembershipRecord.delete_all
    puts "Sidekiq is finished deleting old database."
    puts "Sidekiq is uploading to Rails Postgres Database."
    importer = Import.new()
    puts "Sidekiq is importing constituent."
    importer.import_constituent_csv_data
    puts "Sidekiq finished uploading constituent, now uploading unclean constituent."
    importer.import_uncleanconstituent_csv_data
    puts "Sidekiq finished uploading unclean constituent, now uploading address."
    importer.import_address_csv_data
    puts "Sidekiq finished uploading address, now uploading contact history."
    importer.import_contacthistory_csv_data
    puts "Sidekiq finished uploading contact history, now uploading event."
    importer.import_event_csv_data
    puts "Sidekiq finished uploading event, now uploading constituent event."
    importer.import_constituentevent_csv_data
    puts "Sidekiq finished uploading constituent event, now uploading unclean address."
    importer.import_uncleanaddress_csv_data
    puts "Sidekiq finished uploading unclean address, now uploading donation program."
    importer.import_donationprogram_csv_data
    puts "Sidekiq finished uploading donation program, now uploading donation history."
    importer.import_donationhistory_csv_data
    puts "Sidekiq finished uploading donation history, now uploading membership."
    importer.import_membershiprecord_csv_data
    puts "Sidekiq finished uploading membership, now uploading constituent membership."
    importer.import_constituentmembershiprecord_csv_data
    puts "Sidekiq is finished uploading to the Postgres Database."

    puts "Sidekiq is removing the public csv files generated."
    if File.exist?("#{Rails.root}/public/constituent.csv")
        File.delete("#{Rails.root}/public/constituent.csv")
    end
    if File.exist?("#{Rails.root}/public/membership_record.csv")
        File.delete("#{Rails.root}/public/membership_record.csv")
    end
    if File.exist?("#{Rails.root}/public/incomplete_invalid_constituent.csv")
        File.delete("#{Rails.root}/public/incomplete_invalid_constituent.csv")
    end
    if File.exist?("#{Rails.root}/public/incomplete_invalid_address.csv")
        File.delete("#{Rails.root}/public/incomplete_invalid_address.csv")
    end
    if File.exist?("#{Rails.root}/public/event.csv")
        File.delete("#{Rails.root}/public/event.csv")
    end
    if File.exist?("#{Rails.root}/public/donation_program.csv")
        File.delete("#{Rails.root}/public/donation_program.csv")
    end
    if File.exist?("#{Rails.root}/public/donation_history.csv")
        File.delete("#{Rails.root}/public/donation_history.csv")
    end
    if File.exist?("#{Rails.root}/public/contact_history.csv")
        File.delete("#{Rails.root}/public/contact_history.csv")
    end
    if File.exist?("#{Rails.root}/public/constituent_membership_record.csv")
        File.delete("#{Rails.root}/public/constituent_membership_record.csv")
    end
    if File.exist?("#{Rails.root}/public/constituent_event.csv")
        File.delete("#{Rails.root}/public/constituent_event.csv")
    end
    if File.exist?("#{Rails.root}/public/address.csv")
        File.delete("#{Rails.root}/public/address.csv")
    end
    puts "Sidekiq is finished removing the public csv files generated."

  end

end
