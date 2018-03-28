class CreateConstituentMembershipRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :constituent_membership_records do |t|
      t.text :lookup_id
      t.text :membership_id

      t.timestamps
    end
  end
end
