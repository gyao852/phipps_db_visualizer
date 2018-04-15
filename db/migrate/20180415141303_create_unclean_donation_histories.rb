class CreateUncleanDonationHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :unclean_donation_histories do |t|
      t.text :donation_history_id
      t.text :donation_program_id
      t.text :lookup_id
      t.integer :amount
      t.date :date
      t.text :payment_method
      t.boolean :given_anonymously
      t.boolean :do_not_acknowledge
      t.text :transaction_type
      t.text :error

      t.timestamps
    end
  end
end
