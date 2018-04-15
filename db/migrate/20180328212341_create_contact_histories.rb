class CreateContactHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :contact_histories do |t|
      t.text :lookup_id
      t.text :contact_type
      t.date :date

      t.timestamps
    end
  end
end
