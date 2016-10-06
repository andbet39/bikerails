class MyMeetingController < ApplicationController
  def index
    ride_level = RideLevel.all
    ride_type  =RideType.all
    @props={ride_level: ride_level , ride_type: ride_type}
  end

  def create
  end

  def view
  end
end
