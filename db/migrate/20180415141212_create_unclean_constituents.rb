class CreateUncleanConstituents < ActiveRecord::Migration[5.1]
  def change
    create_table :unclean_constituents do |t|
      t.text :lookup_id
      t.text :suffix
      t.text :title
      t.text :name
      t.text :last_group
      t.text :email_id
      t.text :phone
      t.date :dob
      t.boolean :do_not_email
      t.boolean :duplicate
      t.text :constituent_type
      t.text :phone_notes
      t.boolean :incomplete_names
      t.boolean :invalid_emails
      t.boolean :invalid_phones
      t.boolean :invalid_zips
      t.boolean :no_contact
      t.boolean :duplicate
      t.text    :duplicate_records

      t.timestamps
    end
  end
end
