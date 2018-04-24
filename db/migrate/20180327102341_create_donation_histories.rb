class CreateDonationHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :donation_histories do |t|
      t.text :donation_history_id
      t.text :donation_program_id
      t.text :lookup_id
      t.float :amount
      t.date :date
      t.text :payment_method
      t.boolean :given_anonymously
      t.boolean :do_not_acknowledge
      t.text :transaction_type

      t.timestamps
    end
  end
end
