class AddRefToPartecipation < ActiveRecord::Migration
  def change
    add_reference :participations, :meeting, foreign_key: true
    add_reference :participations, :user, foreign_key: true
  end
end
