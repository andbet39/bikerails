json.track do
    json.partial! "tracks/track", track: @track
    json.points do
       json.array!(@track.points) do |p|
              json.id p.id
              json.lat p.lat
              json.lng p.lng
              json.elevation p.elevation
        end
    end
end