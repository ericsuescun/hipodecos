require 'test_helper'

class InformsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @inform = informs(:one)
  end

  test "should get index" do
    get informs_url
    assert_response :success
  end

  test "should get new" do
    get new_inform_url
    assert_response :success
  end

  test "should create inform" do
    assert_difference('Inform.count') do
      post informs_url, params: { inform: { branch_id: @inform.branch_id, copayment: @inform.copayment, cost: @inform.cost, delivery_date: @inform.delivery_date, entity_id: @inform.entity_id, physician_id: @inform.physician_id, pregnancy_status: @inform.pregnancy_status, price: @inform.price, prmtr_auth_code: @inform.prmtr_auth_code, receive_date: @inform.receive_date, regime: @inform.regime, status: @inform.status, tag_code: @inform.tag_code, user_id: @inform.user_id, zone_type: @inform.zone_type } }
    end

    assert_redirected_to inform_url(Inform.last)
  end

  test "should show inform" do
    get inform_url(@inform)
    assert_response :success
  end

  test "should get edit" do
    get edit_inform_url(@inform)
    assert_response :success
  end

  test "should update inform" do
    patch inform_url(@inform), params: { inform: { branch_id: @inform.branch_id, copayment: @inform.copayment, cost: @inform.cost, delivery_date: @inform.delivery_date, entity_id: @inform.entity_id, physician_id: @inform.physician_id, pregnancy_status: @inform.pregnancy_status, price: @inform.price, prmtr_auth_code: @inform.prmtr_auth_code, receive_date: @inform.receive_date, regime: @inform.regime, status: @inform.status, tag_code: @inform.tag_code, user_id: @inform.user_id, zone_type: @inform.zone_type } }
    assert_redirected_to inform_url(@inform)
  end

  test "should destroy inform" do
    assert_difference('Inform.count', -1) do
      delete inform_url(@inform)
    end

    assert_redirected_to informs_url
  end
end
