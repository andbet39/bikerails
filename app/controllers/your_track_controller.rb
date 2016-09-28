class YourTrackController < ApplicationController

  def index
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

    logger.info ( track.gpx.path )

    gpx_file = GPX::GPXFile.new(:gpx_file => track.gpx.path)
    bound = gpx_file.bounds
    boundstring = bound.min_lat.to_s  << "," << bound.min_lon.to_s << "," << bound.max_lat.to_s << "," <<bound.max_lon.to_s
    logger.info ( boundstring )

    seg = StravaUtils.getSegments boundstring
    @segments =  seg['segments']
        
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
