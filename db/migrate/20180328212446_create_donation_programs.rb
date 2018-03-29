class CreateDonationPrograms < ActiveRecord::Migration[5.1]
  def change
    create_table :donation_programs do |t|
      t.text :donation_program_id
      t.text :program
      t.boolean :active

      t.timestamps
    end
  end
end
