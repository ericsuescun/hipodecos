require 'test_helper'

class FactorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @factor = factors(:one)
  end

  test "should get index" do
    get factors_url
    assert_response :success
  end

  test "should get new" do
    get new_factor_url
    assert_response :success
  end

  test "should create factor" do
    assert_difference('Factor.count') do
      post factors_url, params: { factor: { admin_id: @factor.admin_id, codeval_id: @factor.codeval_id, description: @factor.description, factor: @factor.factor, rate_id: @factor.rate_id } }
    end

    assert_redirected_to factor_url(Factor.last)
  end

  test "should show factor" do
    get factor_url(@factor)
    assert_response :success
  end

  test "should get edit" do
    get edit_factor_url(@factor)
    assert_response :success
  end

  test "should update factor" do
    patch factor_url(@factor), params: { factor: { admin_id: @factor.admin_id, codeval_id: @factor.codeval_id, description: @factor.description, factor: @factor.factor, rate_id: @factor.rate_id } }
    assert_redirected_to factor_url(@factor)
  end

  test "should destroy factor" do
    assert_difference('Factor.count', -1) do
      delete factor_url(@factor)
    end

    assert_redirected_to factors_url
  end
end
