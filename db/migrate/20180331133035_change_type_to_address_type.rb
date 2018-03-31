class ChangeTypeToAddressType < ActiveRecord::Migration[5.1]
  def change
    rename_column :addresses, :type, :address_type
  end
end
