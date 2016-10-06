require 'test_helper'

class RideTypesControllerTest < ActionController::TestCase
  setup do
    @ride_type = ride_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ride_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ride_type" do
    assert_difference('RideType.count') do
      post :create, ride_type: { icon: @ride_type.icon, image: @ride_type.image, name: @ride_type.name }
    end

    assert_redirected_to ride_type_path(assigns(:ride_type))
  end

  test "should show ride_type" do
    get :show, id: @ride_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ride_type
    assert_response :success
  end

  test "should update ride_type" do
    patch :update, id: @ride_type, ride_type: { icon: @ride_type.icon, image: @ride_type.image, name: @ride_type.name }
    assert_redirected_to ride_type_path(assigns(:ride_type))
  end

  test "should destroy ride_type" do
    assert_difference('RideType.count', -1) do
      delete :destroy, id: @ride_type
    end

    assert_redirected_to ride_types_path
  end
end
