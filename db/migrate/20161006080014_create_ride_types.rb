class CreateRideTypes < ActiveRecord::Migration
  def change
    create_table :ride_types do |t|
      t.string :name
      t.string :image
      t.string :icon

      t.timestamps null: false
    end
  end
end
