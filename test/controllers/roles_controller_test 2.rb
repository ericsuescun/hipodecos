require 'test_helper'

class RolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @role = roles(:one)
  end

  test "should get index" do
    get roles_url
    assert_response :success
  end

  test "should get new" do
    get new_role_url
    assert_response :success
  end

  test "should create role" do
    assert_difference('Role.count') do
      post roles_url, params: { role: { admin_id: @role.admin_id, description: @role.description, health_care_rate: @role.health_care_rate, name: @role.name, parafiscal_rate: @role.parafiscal_rate, pension_rate: @role.pension_rate, rate: @role.rate, time: @role.time } }
    end

    assert_redirected_to role_url(Role.last)
  end

  test "should show role" do
    get role_url(@role)
    assert_response :success
  end

  test "should get edit" do
    get edit_role_url(@role)
    assert_response :success
  end

  test "should update role" do
    patch role_url(@role), params: { role: { admin_id: @role.admin_id, description: @role.description, health_care_rate: @role.health_care_rate, name: @role.name, parafiscal_rate: @role.parafiscal_rate, pension_rate: @role.pension_rate, rate: @role.rate, time: @role.time } }
    assert_redirected_to role_url(@role)
  end

  test "should destroy role" do
    assert_difference('Role.count', -1) do
      delete role_url(@role)
    end

    assert_redirected_to roles_url
  end
end
