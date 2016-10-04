class TrackImportController < ApplicationController
  
  require 'fit'

  def index
  end

  def importfit
  
    file = params[:fit_file]

    fit_file = Fit.load_file(file.tempfile)

    db_track = Track.new
    db_track.save!
    
    fit_file.records.select {|r| r.content && r.content.record_type == :record }.each do |r|
        begin
              pr = r.content
              dbpnt =  Point.new
              dbpnt.elevation = pr.altitude.to_f if pr.respond_to?(:altitude)
              dbpnt.lat= convert_position(pr.position_lat) if pr.respond_to?(:position_lat)
              dbpnt.lng  = convert_position(pr.position_long) if pr.respond_to?(:position_lat)
              dbpnt.track = db_track
              dbpnt.distance = pr.distance if pr.respond_to?(:distance)
              dbpnt.rate=0
              if dbpnt.lat != nil || dbpnt.lng != nil
                dbpnt.save!
              end
        rescue => e
          logger.debug {"#{e.message} for #{r}"}
        
        end
    end

  
    render json: "success"
  end



  def import
    
    file = params[:track]
    @allpoints=[]
    gpx_file = GPX::GPXFile.new(:gpx_file => file.tempfile) 

  
    gpx_file.tracks.each() do |track|

      db_track = Track.new
      db_track.gpx  = file

      db_track.save!

      dist=0
      old_pt =nil
      rate = 0
      track.segments.each() do |segment|
        segment.points.each() do |point|
          
          if old_pt != nil
            diff = distance [point.lat,point.lon],[old_pt.lat,old_pt.lon]
            dist += diff
            rate = ((old_pt.elevation - point.elevation)/(dist/100))*100
            
            if rate >20
              rate =20
            end
            if rate < -20 
              rate =-20
            end
          else
            dist=0
          end
          dbpnt =  Point.new
          dbpnt.elevation = point.elevation
          dbpnt.lat= point.lat
          dbpnt.lng  = point.lon
          dbpnt.track = db_track
          dbpnt.distance = dist
          dbpnt.rate=rate
          dbpnt.save!

          old_pt=point
        end
      end
      
    end

    logger.info(@allpoints)

  end

  def view
  
    @all_points=[]
    @alt_pts=[]
    @total_elev=0
    @total_desc=0
    dist =0
    take_by = 30
    diff=0
    counter = take_by
    
    track = Track.find(params[:trk])  
    old_pt=track.points[0]
    old_pt_alt=track.points[take_by]
       
        track.points.each() do |point|
            str = point.lat.to_s + "," + point.lng.to_s
            @all_points << str
   
            dist += distance [point.lat,point.lng],[old_pt.lat,old_pt.lng]
            
            if counter % take_by == 0
              diff = (old_pt_alt.real_elevation ? old_pt_alt.real_elevation : old_pt_alt.elevation )  - (point.real_elevation ? point.real_elevation : point.elevation) 
              if diff > 0
                @total_elev += diff
              end
              if diff < 0
                @total_desc += diff*-1
              end
              @alt_pts << {"x": dist,"y":  (point.real_elevation ? point.real_elevation : point.elevation) }
              old_pt_alt = point
            end
            
          old_pt=point
          counter +=1
        end
    logger.info @alt_pts.to_json

  end
  
  def viewjson
  
    file = File.open('test.gpx')
    
    render json: Gpx2geojson.parse(file)
  end
  
  
  def getrealelevation
    
    base_path="https://maps.googleapis.com/maps/api/elevation/json?key=AIzaSyCkxObmz0mpN1r6mjM-JYg1fQmn_OFDOko&path="
    samples=0
    take_by = 30


    @all_points_str=""
    counter=take_by
    
    track = Track.find(params[:trk])  
    
    track.points.each() do |point|
      str = point.lat.to_s + "," + point.lng.to_s
      if counter % take_by == 0
        @all_points_str = @all_points_str  + str + "|"
        samples +=1
      end
      counter += 1
    end
    
    logger.info @all_points_str.chomp("|")
   
    uri = URI.parse( base_path + @all_points_str.chomp("|") +"&samples="+samples.to_s);
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    req = Net::HTTP::Get.new(uri)
    res = http.request(req)
    
    js = JSON.parse(res.body)
    
    results =  js['results']
    counter=take_by
    samples=0
    
    track.points.each() do |point|
      str = point.lat.to_s + "," + point.lng.to_s
      if counter % take_by == 0
        elev = results[samples]['elevation']
        point.real_elevation = elev
        logger.info  elev
        point.save!
        samples +=1
      end
      counter += 1
    end
        
    render json: res.body
    
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
  
  
  
def convert_position(value)
      (8.381903171539307e-08 * value).round(5)
    end

end
