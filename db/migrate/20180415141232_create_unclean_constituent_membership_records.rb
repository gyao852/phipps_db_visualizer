class CreateUncleanConstituentMembershipRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :unclean_constituent_membership_records do |t|
      t.text :lookup_id
      t.text :membership_id
      t.text :error

      t.timestamps
    end
  end
end
