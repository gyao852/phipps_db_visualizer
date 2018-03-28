class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.integer :user_id
      t.text :fname
      t.text :lname
      t.text :email_id
      t.text :password_digest
      t.boolean :active

      t.timestamps
    end
  end
end
