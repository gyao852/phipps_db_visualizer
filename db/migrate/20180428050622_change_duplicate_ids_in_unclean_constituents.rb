class ChangeDuplicateIdsInUncleanConstituents < ActiveRecord::Migration[5.1]
  def up
    change_column :unclean_constituents, :duplicate_lookup_ids, :text, array: true, default: [], using: "(string_to_array(duplicate_lookup_ids, ','))"
  end
  
  def down
    change_column :unclean_constituents, :duplicate_lookup_ids, :text, array: false, default: nil, using: "(string_to_array(duplicate_lookup_ids, ','))"
  end
end
