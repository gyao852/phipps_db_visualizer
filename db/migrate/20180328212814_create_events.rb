class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.text :event_id
      t.text :event_name
      t.date :start_date_time
      t.date :end_date_time

      t.timestamps
    end
  end
end
