class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.text :event_id
      t.text :event_name
      t.text :category
      t.datetime :start_date_time
      t.datetime :end_date_time

      t.timestamps
    end
  end
end
