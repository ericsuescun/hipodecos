require 'test_helper'

class MacrosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @macro = macros(:one)
  end

  test "should get index" do
    get macros_url
    assert_response :success
  end

  test "should get new" do
    get new_macro_url
    assert_response :success
  end

  test "should create macro" do
    assert_difference('Macro.count') do
      post macros_url, params: { macro: { description: @macro.description, inform_id: @macro.inform_id, user_id: @macro.user_id } }
    end

    assert_redirected_to macro_url(Macro.last)
  end

  test "should show macro" do
    get macro_url(@macro)
    assert_response :success
  end

  test "should get edit" do
    get edit_macro_url(@macro)
    assert_response :success
  end

  test "should update macro" do
    patch macro_url(@macro), params: { macro: { description: @macro.description, inform_id: @macro.inform_id, user_id: @macro.user_id } }
    assert_redirected_to macro_url(@macro)
  end

  test "should destroy macro" do
    assert_difference('Macro.count', -1) do
      delete macro_url(@macro)
    end

    assert_redirected_to macros_url
  end
end
