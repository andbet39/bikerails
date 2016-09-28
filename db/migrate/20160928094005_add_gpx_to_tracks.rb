class AddGpxToTracks < ActiveRecord::Migration
    def change
      add_attachment :tracks, :gpx
    end
end
