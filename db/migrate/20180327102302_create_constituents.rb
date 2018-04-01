class CreateConstituents < ActiveRecord::Migration[5.1]
  def change
    create_table :constituents do |t|
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

    
    end
  end
end
