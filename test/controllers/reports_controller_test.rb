require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get status" do
    get reports_status_url
    assert_response :success
  end

  test "should get objections" do
    get reports_objections_url
    assert_response :success
  end

  test "should get sales" do
    get reports_sales_url
    assert_response :success
  end

end
