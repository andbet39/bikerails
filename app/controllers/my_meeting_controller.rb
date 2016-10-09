class MyMeetingController < ApplicationController
  def index
    ride_level = RideLevel.all
    ride_type  =RideType.all
    @props={ride_level: ride_level , ride_type: ride_type}
  end

  def create
  end

  def view
    @meeting = Meeting.find(params[:meet_id])
    @partecipants = Participation.where(meeting_id: @meeting.id).includes(:user)

    @props={track: @meeting.track, points: @meeting.track.points ,bounds:@meeting.track.bounds}
    @signup_props={current_user: current_user, meeting: @meeting, participations:@partecipants}


  end

  def search
    location = Geokit::Geocoders::MultiGeocoder.geocode(request.remote_ip)
    logger.info(request.remote_ip)
    @props={current_user: current_user,center:location}

  end

end
