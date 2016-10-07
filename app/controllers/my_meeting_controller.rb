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
    @props={track: @meeting.track, points: @meeting.track.points ,bounds:@meeting.track.bounds}
    @signup_props={current_user: current_user, meeting: @meeting}
  end
end
