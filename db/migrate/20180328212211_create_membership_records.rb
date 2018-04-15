class CreateMembershipRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :membership_records do |t|
      t.text :membership_id
      t.text :membership_scheme
      t.text :membership_level
      t.text :add_ons
      t.text :membership_level_type
      t.text :membership_status
      t.date :start_date
      t.date :end_date
      t.date :last_renewed

      t.timestamps
    end
  end
end
