class CreateUncleanConstituentEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :unclean_constituent_events do |t|
      t.text :event_id
      t.text :lookup_id
      t.text :status
      t.boolean :attend
      t.text :error

      t.timestamps
    end
  end
end
