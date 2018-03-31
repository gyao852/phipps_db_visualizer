class AddAddress2ToAddress < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :address_2, :text
  end
end
