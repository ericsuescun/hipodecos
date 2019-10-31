require 'test_helper'

class ObcodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @obcode = obcodes(:one)
  end

  test "should get index" do
    get obcodes_url
    assert_response :success
  end

  test "should get new" do
    get new_obcode_url
    assert_response :success
  end

  test "should create obcode" do
    assert_difference('Obcode.count') do
      post obcodes_url, params: { obcode: { admin_id: @obcode.admin_id, order: @obcode.order, process: @obcode.process, score: @obcode.score, title: @obcode.title } }
    end

    assert_redirected_to obcode_url(Obcode.last)
  end

  test "should show obcode" do
    get obcode_url(@obcode)
    assert_response :success
  end

  test "should get edit" do
    get edit_obcode_url(@obcode)
    assert_response :success
  end

  test "should update obcode" do
    patch obcode_url(@obcode), params: { obcode: { admin_id: @obcode.admin_id, order: @obcode.order, process: @obcode.process, score: @obcode.score, title: @obcode.title } }
    assert_redirected_to obcode_url(@obcode)
  end

  test "should destroy obcode" do
    assert_difference('Obcode.count', -1) do
      delete obcode_url(@obcode)
    end

    assert_redirected_to obcodes_url
  end
end
