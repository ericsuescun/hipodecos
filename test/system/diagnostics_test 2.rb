require "application_system_test_case"

class DiagnosticsTest < ApplicationSystemTestCase
  setup do
    @diagnostic = diagnostics(:one)
  end

  test "visiting the index" do
    visit diagnostics_url
    assert_selector "h1", text: "Diagnostics"
  end

  test "creating a Diagnostic" do
    visit diagnostics_url
    click_on "New Diagnostic"

    fill_in "Description", with: @diagnostic.description
    fill_in "Inform", with: @diagnostic.inform_id
    fill_in "User", with: @diagnostic.user_id
    click_on "Create Diagnostic"

    assert_text "Diagnostic was successfully created"
    click_on "Back"
  end

  test "updating a Diagnostic" do
    visit diagnostics_url
    click_on "Edit", match: :first

    fill_in "Description", with: @diagnostic.description
    fill_in "Inform", with: @diagnostic.inform_id
    fill_in "User", with: @diagnostic.user_id
    click_on "Update Diagnostic"

    assert_text "Diagnostic was successfully updated"
    click_on "Back"
  end

  test "destroying a Diagnostic" do
    visit diagnostics_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Diagnostic was successfully destroyed"
  end
end
