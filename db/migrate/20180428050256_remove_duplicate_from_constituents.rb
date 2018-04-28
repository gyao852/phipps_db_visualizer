class RemoveDuplicateFromConstituents < ActiveRecord::Migration[5.1]
  def change
    remove_column :constituents, :duplicate, :boolean
  end
end
