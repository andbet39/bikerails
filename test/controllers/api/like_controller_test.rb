require 'test_helper'

class Api::LikeControllerTest < ActionController::TestCase
  test "should get like" do
    get :like
    assert_response :success
  end

  test "should get dislike" do
    get :dislike
    assert_response :success
  end

  test "should get getvotes" do
    get :getvotes
    assert_response :success
  end

end
