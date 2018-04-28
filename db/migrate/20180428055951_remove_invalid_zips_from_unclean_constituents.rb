class RemoveInvalidZipsFromUncleanConstituents < ActiveRecord::Migration[5.1]
  def change
    remove_column :unclean_constituents, :invalid_zips, :boolean
  end
end
