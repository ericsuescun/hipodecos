require 'test_helper'

class AutomaticsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @automatic = automatics(:one)
  end

  test "should get index" do
    get automatics_url
    assert_response :success
  end

  test "should get new" do
    get new_automatic_url
    assert_response :success
  end

  test "should create automatic" do
    assert_difference('Automatic.count') do
      post automatics_url, params: { automatic: { organ: @automatic.organ, title: @automatic.title } }
    end

    assert_redirected_to automatic_url(Automatic.last)
  end

  test "should show automatic" do
    get automatic_url(@automatic)
    assert_response :success
  end

  test "should get edit" do
    get edit_automatic_url(@automatic)
    assert_response :success
  end

  test "should update automatic" do
    patch automatic_url(@automatic), params: { automatic: { organ: @automatic.organ, title: @automatic.title } }
    assert_redirected_to automatic_url(@automatic)
  end

  test "should destroy automatic" do
    assert_difference('Automatic.count', -1) do
      delete automatic_url(@automatic)
    end

    assert_redirected_to automatics_url
  end
end
