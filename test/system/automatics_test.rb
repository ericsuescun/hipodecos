require "application_system_test_case"

class AutomaticsTest < ApplicationSystemTestCase
  setup do
    @automatic = automatics(:one)
  end

  test "visiting the index" do
    visit automatics_url
    assert_selector "h1", text: "Automatics"
  end

  test "creating a Automatic" do
    visit automatics_url
    click_on "New Automatic"

    fill_in "Organ", with: @automatic.organ
    fill_in "Title", with: @automatic.title
    click_on "Create Automatic"

    assert_text "Automatic was successfully created"
    click_on "Back"
  end

  test "updating a Automatic" do
    visit automatics_url
    click_on "Edit", match: :first

    fill_in "Organ", with: @automatic.organ
    fill_in "Title", with: @automatic.title
    click_on "Update Automatic"

    assert_text "Automatic was successfully updated"
    click_on "Back"
  end

  test "destroying a Automatic" do
    visit automatics_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Automatic was successfully destroyed"
  end
end
