class AddDistanceToPoints < ActiveRecord::Migration
  def change
    add_column :points, :distance, :float
  end
end
