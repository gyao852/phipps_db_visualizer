class CreateContactHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :contact_histories do |t|
      t.text :contact_history_id
      t.text :lookup_id
      t.text :type
      t.date :date

      t.timestamps
    end
  end
end
