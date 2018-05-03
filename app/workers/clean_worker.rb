class CleanWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform()
    puts "Sidekiq is running the cleaning script."
    `python3 public/cleaning_script.py`
    puts "Sidekiq is finished with the cleaning script."
  end

end
