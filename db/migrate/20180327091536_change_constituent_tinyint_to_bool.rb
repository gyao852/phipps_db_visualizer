class ChangeConstituentTinyintToBool < ActiveRecord::Migration[5.1]
  def change
    change_column :constituent, :do_not_email, :boolean
    change_column :constituent, :duplicate, :boolean
  end
end
