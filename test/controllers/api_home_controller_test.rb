require 'test_helper'

class ApiHomeControllerTest < ActionController::TestCase
  test "should get addEvent" do
    get :addEvent
    assert_response :success
  end

  test "should get allEvents" do
    get :allEvents
    assert_response :success
  end

end
