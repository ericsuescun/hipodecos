require "application_system_test_case"

class ScriptsTest < ApplicationSystemTestCase
  setup do
    @script = scripts(:one)
  end

  test "visiting the index" do
    visit scripts_url
    assert_selector "h1", text: "Scripts"
  end

  test "creating a Script" do
    visit scripts_url
    click_on "New Script"

    fill_in "Automatic", with: @script.automatic_id
    fill_in "Description", with: @script.description
    fill_in "Organ", with: @script.organ
    fill_in "Param1", with: @script.param1
    fill_in "Param2", with: @script.param2
    fill_in "Script order", with: @script.script_order
    fill_in "Script type", with: @script.script_type
    click_on "Create Script"

    assert_text "Script was successfully created"
    click_on "Back"
  end

  test "updating a Script" do
    visit scripts_url
    click_on "Edit", match: :first

    fill_in "Automatic", with: @script.automatic_id
    fill_in "Description", with: @script.description
    fill_in "Organ", with: @script.organ
    fill_in "Param1", with: @script.param1
    fill_in "Param2", with: @script.param2
    fill_in "Script order", with: @script.script_order
    fill_in "Script type", with: @script.script_type
    click_on "Update Script"

    assert_text "Script was successfully updated"
    click_on "Back"
  end

  test "destroying a Script" do
    visit scripts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Script was successfully destroyed"
  end
end
