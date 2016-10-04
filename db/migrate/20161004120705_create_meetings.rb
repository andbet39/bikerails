class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.string :title
      t.float :start_lat
      t.float :start_lng
      t.datetime :start_time
      t.float :duration

      t.timestamps null: false
    end
  end
end
