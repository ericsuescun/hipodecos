require 'test_helper'

class CitocodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @citocode = citocodes(:one)
  end

  test "should get index" do
    get citocodes_url
    assert_response :success
  end

  test "should get new" do
    get new_citocode_url
    assert_response :success
  end

  test "should create citocode" do
    assert_difference('Citocode.count') do
      post citocodes_url, params: { citocode: { admin_id: @citocode.admin_id, cito_code: @citocode.cito_code, description: @citocode.description, order: @citocode.order, result_type: @citocode.result_type, score: @citocode.score } }
    end

    assert_redirected_to citocode_url(Citocode.last)
  end

  test "should show citocode" do
    get citocode_url(@citocode)
    assert_response :success
  end

  test "should get edit" do
    get edit_citocode_url(@citocode)
    assert_response :success
  end

  test "should update citocode" do
    patch citocode_url(@citocode), params: { citocode: { admin_id: @citocode.admin_id, cito_code: @citocode.cito_code, description: @citocode.description, order: @citocode.order, result_type: @citocode.result_type, score: @citocode.score } }
    assert_redirected_to citocode_url(@citocode)
  end

  test "should destroy citocode" do
    assert_difference('Citocode.count', -1) do
      delete citocode_url(@citocode)
    end

    assert_redirected_to citocodes_url
  end
end
