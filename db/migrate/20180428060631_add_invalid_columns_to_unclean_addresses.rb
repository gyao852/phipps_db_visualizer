class AddInvalidColumnsToUncleanAddresses < ActiveRecord::Migration[5.1]
  def change
    add_column :unclean_addresses, :invalid_addresses_1, :boolean
    add_column :unclean_addresses, :invalid_cities, :boolean
    add_column :unclean_addresses, :invalid_states, :boolean
    add_column :unclean_addresses, :invalid_countries, :boolean
    add_column :unclean_addresses, :invalid_zips, :boolean
  end
end
