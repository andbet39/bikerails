require 'test_helper'

class Api::StravaSegmentControllerTest < ActionController::TestCase
  test "should get getForTrack" do
    get :getForTrack
    assert_response :success
  end

  test "should get getForBounds" do
    get :getForBounds
    assert_response :success
  end

end
