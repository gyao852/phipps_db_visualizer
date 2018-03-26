class CreateConstituents < ActiveRecord::Migration[5.1]
  def change
    create_table :constituents do |t|
      t.integer :lookup_id
      t.text :suffix
      t.text :title
      t.text :name
      t.text :last_group
      t.text :email_id
      t.text :phone
      t.date :dob
      t.tinyint :do_not_email
      t.tinyint :duplicate

      t.timestamps
    end
  end
end
