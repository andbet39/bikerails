class CreateRideLevels < ActiveRecord::Migration
  def change
    create_table :ride_levels do |t|
      t.string :name
      t.integer :val

      t.timestamps null: false
    end
  end
end
