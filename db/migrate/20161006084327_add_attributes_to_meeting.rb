class AddAttributesToMeeting < ActiveRecord::Migration
  def change
        add_reference :meetings, :track, foreign_key: true
        add_reference :meetings, :ride_level, foreign_key: true
        add_reference :meetings, :ride_type, foreign_key: true
  end
end
