class CreateGoals < ActiveRecord::Migration[5.1]
  def change
    create_table :goals do |t|
      t.integer :userid
      t.integer :year
      t.integer :goal

      t.timestamps
    end
  end
end
