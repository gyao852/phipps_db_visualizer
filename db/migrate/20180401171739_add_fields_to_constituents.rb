class AddFieldsToConstituents < ActiveRecord::Migration[5.1]
  def change
    add_column :constituents, :constituent_type, :text
    add_column :constituents, :phone_notes, :text
  end
end
