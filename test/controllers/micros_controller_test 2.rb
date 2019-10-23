require 'test_helper'

class MicrosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @micro = micros(:one)
  end

  test "should get index" do
    get micros_url
    assert_response :success
  end

  test "should get new" do
    get new_micro_url
    assert_response :success
  end

  test "should create micro" do
    assert_difference('Micro.count') do
      post micros_url, params: { micro: { description: @micro.description, inform_id: @micro.inform_id, user_id: @micro.user_id } }
    end

    assert_redirected_to micro_url(Micro.last)
  end

  test "should show micro" do
    get micro_url(@micro)
    assert_response :success
  end

  test "should get edit" do
    get edit_micro_url(@micro)
    assert_response :success
  end

  test "should update micro" do
    patch micro_url(@micro), params: { micro: { description: @micro.description, inform_id: @micro.inform_id, user_id: @micro.user_id } }
    assert_redirected_to micro_url(@micro)
  end

  test "should destroy micro" do
    assert_difference('Micro.count', -1) do
      delete micro_url(@micro)
    end

    assert_redirected_to micros_url
  end
end
