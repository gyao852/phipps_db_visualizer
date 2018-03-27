class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.text :address_id
      t.text :lookup_id
      t.text :address_1
      t.text :city
      t.text :state
      t.text :zip
      t.text :country
      t.text :type
      t.date :start_date

      t.timestamps
    end
  end
end
