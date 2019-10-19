require "application_system_test_case"

class CodevalsTest < ApplicationSystemTestCase
  setup do
    @codeval = codevals(:one)
  end

  test "visiting the index" do
    visit codevals_url
    assert_selector "h1", text: "Codevals"
  end

  test "creating a Codeval" do
    visit codevals_url
    click_on "New Codeval"

    fill_in "Admin", with: @codeval.admin_id
    fill_in "Code", with: @codeval.code
    fill_in "Description", with: @codeval.description
    fill_in "Name", with: @codeval.name
    fill_in "Oms code", with: @codeval.oms_code
    fill_in "Origin system", with: @codeval.origin_system
    click_on "Create Codeval"

    assert_text "Codeval was successfully created"
    click_on "Back"
  end

  test "updating a Codeval" do
    visit codevals_url
    click_on "Edit", match: :first

    fill_in "Admin", with: @codeval.admin_id
    fill_in "Code", with: @codeval.code
    fill_in "Description", with: @codeval.description
    fill_in "Name", with: @codeval.name
    fill_in "Oms code", with: @codeval.oms_code
    fill_in "Origin system", with: @codeval.origin_system
    click_on "Update Codeval"

    assert_text "Codeval was successfully updated"
    click_on "Back"
  end

  test "destroying a Codeval" do
    visit codevals_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Codeval was successfully destroyed"
  end
end
