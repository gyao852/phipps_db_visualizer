class CreateUncleanContactHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :unclean_contact_histories do |t|
      t.text :contact_history_id
      t.text :lookup_id
      t.text :contact_type
      t.date :date
      t.text :error

      t.timestamps
    end
  end
end
