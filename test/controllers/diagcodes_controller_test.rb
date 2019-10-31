require 'test_helper'

class DiagcodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @diagcode = diagcodes(:one)
  end

  test "should get index" do
    get diagcodes_url
    assert_response :success
  end

  test "should get new" do
    get new_diagcode_url
    assert_response :success
  end

  test "should create diagcode" do
    assert_difference('Diagcode.count') do
      post diagcodes_url, params: { diagcode: { admin_id: @diagcode.admin_id, description: @diagcode.description, feature1: @diagcode.feature1, feature2: @diagcode.feature2, feature3: @diagcode.feature3, feature4: @diagcode.feature4, feature5: @diagcode.feature5, order: @diagcode.order, organ: @diagcode.organ, pss_code: @diagcode.pss_code, score: @diagcode.score, who_code: @diagcode.who_code } }
    end

    assert_redirected_to diagcode_url(Diagcode.last)
  end

  test "should show diagcode" do
    get diagcode_url(@diagcode)
    assert_response :success
  end

  test "should get edit" do
    get edit_diagcode_url(@diagcode)
    assert_response :success
  end

  test "should update diagcode" do
    patch diagcode_url(@diagcode), params: { diagcode: { admin_id: @diagcode.admin_id, description: @diagcode.description, feature1: @diagcode.feature1, feature2: @diagcode.feature2, feature3: @diagcode.feature3, feature4: @diagcode.feature4, feature5: @diagcode.feature5, order: @diagcode.order, organ: @diagcode.organ, pss_code: @diagcode.pss_code, score: @diagcode.score, who_code: @diagcode.who_code } }
    assert_redirected_to diagcode_url(@diagcode)
  end

  test "should destroy diagcode" do
    assert_difference('Diagcode.count', -1) do
      delete diagcode_url(@diagcode)
    end

    assert_redirected_to diagcodes_url
  end
end
