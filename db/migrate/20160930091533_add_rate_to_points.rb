class AddRateToPoints < ActiveRecord::Migration
  def change
        add_column :points, :rate, :float

  end
end
