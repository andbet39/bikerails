class AddUserToMeetings < ActiveRecord::Migration
  def change
    add_reference :meetings, :user, foreign_key: true
  end
end
