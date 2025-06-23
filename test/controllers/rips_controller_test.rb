require "test_helper"

class RipsControllerTest < ActionDispatch::IntegrationTest
  test "should get procedures" do
    get rips_procedures_url
    assert_response :success
  end

  test "should get users" do
    get rips_users_url
    assert_response :success
  end
end
