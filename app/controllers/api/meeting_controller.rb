class Api::MeetingController < ApplicationController

  def search

    origin_lat=params[:origin_lat]
    origin_lng=params[:origin_lng]
    ride_level=params[:ride_level]
    ride_type=params[:ride_type]
    startdate=params[:startdate]

    radius=params[:radius]
    @meetings = Meeting.all.limit(100)

    if params[:bounds_sw]
      bounds_sw=params[:bounds_sw].split(',')
      bounds_ne=params[:bounds_ne].split(',')
      @meetings = @meetings.in_bounds([bounds_sw,bounds_ne], :origin => [41,12])
    end

    if ride_level
      logger.info("RIDE_LEVEL")
      @meetings = @meetings.where(ride_level_id:ride_level)
    end

    if ride_type
      logger.info("RIDE_TYPE")
      @meetings = @meetings.where(ride_type_id:ride_type)
    end

    if startdate
      logger.info("START_DATE")
      @meetings = @meetings.where('start_time > ?', startdate )
    end

    if origin_lat
      logger.info("ORIGIN")
      @meetings = @meetings.within(50,:origin => [origin_lat,origin_lng])
    end

    render json: @meetings

  end

end
