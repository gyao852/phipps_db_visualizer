class CreateUncleanDonationPrograms < ActiveRecord::Migration[5.1]
  def change
    create_table :unclean_donation_programs do |t|
      t.text :donation_program_id
      t.text :program
      t.text :error

      t.timestamps
    end
  end
end
