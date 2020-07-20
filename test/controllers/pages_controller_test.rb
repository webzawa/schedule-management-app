require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get pages_home_url
    assert_response :success
  end

  test "should get workschedule" do
    get schedules_workschedule_url
    assert_response :success
  end

  test "should get requestschedule" do
    get schedules_requestschedule_url
    assert_response :success
  end

  test "should get approveschedule" do
    get schedules_approveschedule_url
    assert_response :success
  end

end
