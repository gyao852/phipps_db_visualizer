class ImportWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(f1,f2,f3,f4)
    # Importing data
    puts "Sidekiq is reading and uploading the files."
    importer = Import.new(f1,f2,f3,f4)
    importer.save_cmuteamconstituentsexport_csv_file
    importer.save_cmuteamdonationsexport_csv_file
    importer.save_cmuteamcontacthistoryexport_csv_file
    importer.save_cmuteameventattendanceexport_csv_file
    puts "Sidekiq is finished uploading the files."

    # Cleaning data
    puts "Sidekiq is running the cleaning script."
    `python3 public/cleaning_script.py`
    puts "Sidekiq is finished with the cleaning script."
  end

end
