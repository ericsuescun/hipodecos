require 'test_helper'

class AutosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auto = autos(:one)
  end

  test "should get index" do
    get autos_url
    assert_response :success
  end

  test "should get new" do
    get new_auto_url
    assert_response :success
  end

  test "should create auto" do
    assert_difference('Auto.count') do
      post autos_url, params: { auto: { admin_id: @auto.admin_id, body: @auto.body, dx_table_id: @auto.dx_table_id, param1: @auto.param1, param2: @auto.param2, param3: @auto.param3, param4: @auto.param4, title: @auto.title, user_id: @auto.user_id } }
    end

    assert_redirected_to auto_url(Auto.last)
  end

  test "should show auto" do
    get auto_url(@auto)
    assert_response :success
  end

  test "should get edit" do
    get edit_auto_url(@auto)
    assert_response :success
  end

  test "should update auto" do
    patch auto_url(@auto), params: { auto: { admin_id: @auto.admin_id, body: @auto.body, dx_table_id: @auto.dx_table_id, param1: @auto.param1, param2: @auto.param2, param3: @auto.param3, param4: @auto.param4, title: @auto.title, user_id: @auto.user_id } }
    assert_redirected_to auto_url(@auto)
  end

  test "should destroy auto" do
    assert_difference('Auto.count', -1) do
      delete auto_url(@auto)
    end

    assert_redirected_to autos_url
  end
end
