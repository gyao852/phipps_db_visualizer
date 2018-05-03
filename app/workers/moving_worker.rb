class MovingWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(f1,f2,f3,f4)
    puts "Sidekiq is uploading the files."
    importer = Import.new(f1,f2,f3,f4)
    importer.save_cmuteamconstituentsexport_csv_file
    importer.save_cmuteamdonationsexport_csv_file
    importer.save_cmuteamcontacthistoryexport_csv_file
    importer.save_cmuteameventattendanceexport_csv_file
    puts "Sidekiq is finished uploading the files."
  end

end
