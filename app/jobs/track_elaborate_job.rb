class TrackElaborateJob < ActiveJob::Base
  queue_as :default

  def perform( track )

    puts "------------- Start working on track #{track}-----"
    dbtrack  = Track.find(track)

    gpx_file = GPX::GPXFile.new(:gpx_file => dbtrack.gpx.path)
    points = []
    total_elev=0
    total_desc=0
    dist=0

    dbtrack.points.destroy_all

    gpx_file.tracks.each() do |track|

      old_pt=track.points[0]

      track.segments.each() do |segment|
        segment.points.each() do |point|

          dist += distance [point.lat,point.lon],[old_pt.lat,old_pt.lon]


            diff = (old_pt.elevation )  - ( point.elevation)
            if diff > 0
              total_elev += diff
            end
            if diff < 0
              total_desc += diff*-1
            end

          old_pt=point

          dbtrack.points.create( elevation: point.elevation, lat: point.lat, lng: point.lon,distance:dist,time:point.time )
          points << [ point.lat, point.lon]


        end
      end
    end

    dbtrack.is_elaborate = true
    dbtrack.polyline = Polylines::Encoder.encode_points(points)
    dbtrack.descent = total_desc
    dbtrack.length = dist
    dbtrack.ascention = total_elev
    dbtrack.save
    logger.info("------------- End working on track")


  end

  def distance loc1, loc2
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters

    dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
    dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

    lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    rm * c # Delta in meters
  end

end
