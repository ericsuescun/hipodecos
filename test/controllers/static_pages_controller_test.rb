require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get static_pages_home_url
    assert_response :success
  end

  test "should get services" do
    get static_pages_services_url
    assert_response :success
  end

  test "should get whoweare" do
    get static_pages_whoweare_url
    assert_response :success
  end

  test "should get contact" do
    get static_pages_contact_url
    assert_response :success
  end

  test "should get help" do
    get static_pages_help_url
    assert_response :success
  end

  test "should get faq" do
    get static_pages_faq_url
    assert_response :success
  end

  test "should get results" do
    get static_pages_results_url
    assert_response :success
  end

  test "should get tech" do
    get static_pages_tech_url
    assert_response :success
  end

  test "should get portfolio" do
    get static_pages_portfolio_url
    assert_response :success
  end

  test "should get offices" do
    get static_pages_offices_url
    assert_response :success
  end

end
