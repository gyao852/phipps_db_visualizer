class CreateUncleanEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :unclean_events do |t|
      t.text :event_id
      t.text :event_name
      t.date :start_date_time
      t.date :end_date_time
      t.text :error

      t.timestamps
    end
  end
end
