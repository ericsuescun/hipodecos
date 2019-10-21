require "application_system_test_case"

class MicrosTest < ApplicationSystemTestCase
  setup do
    @micro = micros(:one)
  end

  test "visiting the index" do
    visit micros_url
    assert_selector "h1", text: "Micros"
  end

  test "creating a Micro" do
    visit micros_url
    click_on "New Micro"

    fill_in "Description", with: @micro.description
    fill_in "Inform", with: @micro.inform_id
    fill_in "User", with: @micro.user_id
    click_on "Create Micro"

    assert_text "Micro was successfully created"
    click_on "Back"
  end

  test "updating a Micro" do
    visit micros_url
    click_on "Edit", match: :first

    fill_in "Description", with: @micro.description
    fill_in "Inform", with: @micro.inform_id
    fill_in "User", with: @micro.user_id
    click_on "Update Micro"

    assert_text "Micro was successfully updated"
    click_on "Back"
  end

  test "destroying a Micro" do
    visit micros_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Micro was successfully destroyed"
  end
end
