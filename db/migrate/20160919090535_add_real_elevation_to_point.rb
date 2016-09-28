class AddRealElevationToPoint < ActiveRecord::Migration
  def change
    add_column  :points , :real_elevation , :float
  end
end
