class AddElabInfoToTrack < ActiveRecord::Migration
  def change
    add_column :tracks , :is_elaborate , :boolean
    add_column :tracks , :polyline , :string

  end
end
