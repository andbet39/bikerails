class AddInfoToTrack < ActiveRecord::Migration
  def change
    add_column :tracks , :ascention, :float
    add_column :tracks , :length, :float
    add_column :tracks , :descent, :float

  end
end
