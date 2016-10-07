class Api::TrackController < ApplicationController

  require  'polylines'


  def elaborate
      dbtrack  = Track.find(params[:trk])

      gpx_file = GPX::GPXFile.new(:gpx_file => dbtrack.gpx.path)
      points = []
      dbtrack.points.delete_all
        gpx_file.tracks.each() do |track|
        track.segments.each() do |segment|
            segment.points.each() do |point|
              dbtrack.points.create( elevation: point.elevation, lat: point.lat, lng: point.lon )
              points << [ point.lat, point.lon]
            end
          end
      end

      dbtrack.is_elaborate = true
      dbtrack.polyline = Polylines::Encoder.encode_points(points)
      dbtrack.save

      render json: dbtrack

    end

    def import
        file = params[:file]
        @allpoints=[]
        gpx_file = GPX::GPXFile.new(:gpx_file => file.tempfile) 
          
        @track = Track.new
        @track.gpx  = file
        @track.save!
        
        
        #gpx_file.tracks.each() do |track|
        #  track.segments.each() do |segment|
        #    segment.points.each() do |point|
        #      @track.points.create( elevation: point.elevation, lat: point.lat, lng: point.lon )
        #       response.stream.write "Progress"
        #     end
        #  end
        #end
        
       respond_to do |format|
          if @track.save
            format.html { redirect_to @track, notice: 'Track was successfully created.' }
            format.json { render :show, status: :created, location: @track }
          else
            format.html { render :new }
            format.json { render json: @track.errors, status: :unprocessable_entity }
          end
        end
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
