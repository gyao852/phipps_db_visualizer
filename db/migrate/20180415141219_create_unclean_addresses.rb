class CreateUncleanAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :unclean_addresses do |t|
      t.text :address_id
      t.text :lookup_id
      t.text :address_1
      t.text :city
      t.text :state
      t.text :zip
      t.text :country
      t.text :address_type
      t.date :date_added
      t.boolean :invalid_address_1
      t.boolean :invalid_cities
      t.boolean :invalid_states
      t.boolean :invalid_countries
      t.boolean :invalid_zips

      t.timestamps
    end
  end
end
