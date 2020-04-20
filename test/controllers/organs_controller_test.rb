require 'test_helper'

class OrgansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organ = organs(:one)
  end

  test "should get index" do
    get organs_url
    assert_response :success
  end

  test "should get new" do
    get new_organ_url
    assert_response :success
  end

  test "should create organ" do
    assert_difference('Organ.count') do
      post organs_url, params: { organ: { admin_id: @organ.admin_id, organ: @organ.organ, organ_code: @organ.organ_code } }
    end

    assert_redirected_to organ_url(Organ.last)
  end

  test "should show organ" do
    get organ_url(@organ)
    assert_response :success
  end

  test "should get edit" do
    get edit_organ_url(@organ)
    assert_response :success
  end

  test "should update organ" do
    patch organ_url(@organ), params: { organ: { admin_id: @organ.admin_id, organ: @organ.organ, organ_code: @organ.organ_code } }
    assert_redirected_to organ_url(@organ)
  end

  test "should destroy organ" do
    assert_difference('Organ.count', -1) do
      delete organ_url(@organ)
    end

    assert_redirected_to organs_url
  end
end
