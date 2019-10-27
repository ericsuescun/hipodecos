require 'test_helper'

class ObjectionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get objections_index_url
    assert_response :success
  end

  test "should get new" do
    get objections_new_url
    assert_response :success
  end

  test "should get create" do
    get objections_create_url
    assert_response :success
  end

  test "should get edit" do
    get objections_edit_url
    assert_response :success
  end

  test "should get update" do
    get objections_update_url
    assert_response :success
  end

  test "should get delete" do
    get objections_delete_url
    assert_response :success
  end

  test "should get show" do
    get objections_show_url
    assert_response :success
  end

end
