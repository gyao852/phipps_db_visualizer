class CreateDonationHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :donation_histories do |t|
      t.integer :donation_history_id
      t.text :lookup_id
      t.integer :amount
      t.date :date
      t.text :method
      t.boolean :do_not_acknowledge
      t.boolean :given_anonymously
      t.text :transaction_type

      t.timestamps
    end
  end
end
