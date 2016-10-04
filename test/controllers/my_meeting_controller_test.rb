require 'test_helper'

class MyMeetingControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get view" do
    get :view
    assert_response :success
  end

end
