require 'test_helper'

class RideLevelsControllerTest < ActionController::TestCase
  setup do
    @ride_level = ride_levels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ride_levels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ride_level" do
    assert_difference('RideLevel.count') do
      post :create, ride_level: { name: @ride_level.name, val: @ride_level.val }
    end

    assert_redirected_to ride_level_path(assigns(:ride_level))
  end

  test "should show ride_level" do
    get :show, id: @ride_level
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ride_level
    assert_response :success
  end

  test "should update ride_level" do
    patch :update, id: @ride_level, ride_level: { name: @ride_level.name, val: @ride_level.val }
    assert_redirected_to ride_level_path(assigns(:ride_level))
  end

  test "should destroy ride_level" do
    assert_difference('RideLevel.count', -1) do
      delete :destroy, id: @ride_level
    end

    assert_redirected_to ride_levels_path
  end
end
