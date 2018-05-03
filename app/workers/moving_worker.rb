class MovingWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(f1,f2,f3,f4)
    puts "Sidekiq is reading and uploading the files."
    importer = Import.new(f1,f2,f3,f4)
    importer.save_cmuteamconstituentsexport_csv_file
    importer.save_cmuteamdonationsexport_csv_file
    importer.save_cmuteamcontacthistoryexport_csv_file
    importer.save_cmuteameventattendanceexport_csv_file
    if File.exist?("#{Rails.root}/public/CMU Team Constituents Export.csv")
      File.delete("#{Rails.root}/public/CMU Team Constituents Export.csv")
    end
    if File.exist?("#{Rails.root}/public/CMU Team Donations Export.csv")
      File.delete("#{Rails.root}/public/CMU Team Donations Export.csv")
    end
    if File.exist?("#{Rails.root}/public/CMU Team Event Attendance Export.csv")
      File.delete("#{Rails.root}/public/CMU Team Event Attendance Export.csv")
    end
    if File.exist?("#{Rails.root}/public/CMU Team Contact History Export.csv")
      File.delete("#{Rails.root}/public/CMU Team Contact History Export.csv")
    end
    if File.exist?("#{Rails.root}/public/cmuTeamEventExport.csv")
      File.delete("#{Rails.root}/public/cmuTeamEventExport.csv")
    end
    if File.exist?("#{Rails.root}/public/cmuTeamDonationProgramExport.csv")
      File.delete("#{Rails.root}/public/cmuTeamDonationProgramExport.csv")
    end
    puts "Sidekiq is finished uploading the files."
  end

end
