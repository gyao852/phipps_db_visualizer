class CreateConstituentEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :constituent_events do |t|
      t.text :lookup_id
      t.text :event_id
      t.text :status
      t.boolean :attend
      t.text :host_name

      t.timestamps
    end
  end
end
