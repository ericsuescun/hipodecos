require "application_system_test_case"

class MacrosTest < ApplicationSystemTestCase
  setup do
    @macro = macros(:one)
  end

  test "visiting the index" do
    visit macros_url
    assert_selector "h1", text: "Macros"
  end

  test "creating a Macro" do
    visit macros_url
    click_on "New Macro"

    fill_in "Description", with: @macro.description
    fill_in "Inform", with: @macro.inform_id
    fill_in "User", with: @macro.user_id
    click_on "Create Macro"

    assert_text "Macro was successfully created"
    click_on "Back"
  end

  test "updating a Macro" do
    visit macros_url
    click_on "Edit", match: :first

    fill_in "Description", with: @macro.description
    fill_in "Inform", with: @macro.inform_id
    fill_in "User", with: @macro.user_id
    click_on "Update Macro"

    assert_text "Macro was successfully updated"
    click_on "Back"
  end

  test "destroying a Macro" do
    visit macros_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Macro was successfully destroyed"
  end
end
