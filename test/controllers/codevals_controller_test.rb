require 'test_helper'

class CodevalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @codeval = codevals(:one)
  end

  test "should get index" do
    get codevals_url
    assert_response :success
  end

  test "should get new" do
    get new_codeval_url
    assert_response :success
  end

  test "should create codeval" do
    assert_difference('Codeval.count') do
      post codevals_url, params: { codeval: { code: @codeval.code, description: @codeval.description, oms_code: @codeval.oms_code, origin_system: @codeval.origin_system } }
    end

    assert_redirected_to codeval_url(Codeval.last)
  end

  test "should show codeval" do
    get codeval_url(@codeval)
    assert_response :success
  end

  test "should get edit" do
    get edit_codeval_url(@codeval)
    assert_response :success
  end

  test "should update codeval" do
    patch codeval_url(@codeval), params: { codeval: { code: @codeval.code, description: @codeval.description, oms_code: @codeval.oms_code, origin_system: @codeval.origin_system } }
    assert_redirected_to codeval_url(@codeval)
  end

  test "should destroy codeval" do
    assert_difference('Codeval.count', -1) do
      delete codeval_url(@codeval)
    end

    assert_redirected_to codevals_url
  end
end
