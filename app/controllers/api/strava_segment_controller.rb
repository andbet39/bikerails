class Api::StravaSegmentController < ApplicationController
  def getForTrack
    
    track = Track.find(params[:id])
    
    max_lat = track.points.max_by(&:lat).lat
    min_lat = track.points.min_by(&:lat).lat
    max_lng = track.points.max_by(&:lng).lng
    min_lng = track.points.min_by(&:lng).lng

    bound={ "min_lat" => min_lat , "max_lat"=>max_lat , "min_lon" => min_lng, "max_lon" => max_lng }
    
    boundstring = bound['min_lat'].to_s  << "," << bound['min_lon'].to_s << "," << bound['max_lat'].to_s << "," << bound['max_lon'].to_s
    
    seg = StravaUtils.getSegments boundstring
    @segments =  seg['segments']
    
    render json: @segments
  end

  def getForBounds
  end
end
