require "application_system_test_case"

class UtilityFilesTest < ApplicationSystemTestCase
  setup do
    @utility_file = utility_files(:one)
  end

  test "visiting the index" do
    visit utility_files_url
    assert_selector "h1", text: "Utility Files"
  end

  test "creating a Utility file" do
    visit utility_files_url
    click_on "New Utility File"

    fill_in "Description", with: @utility_file.description
    fill_in "Filepath", with: @utility_file.filepath
    fill_in "Name", with: @utility_file.name
    click_on "Create Utility file"

    assert_text "Utility file was successfully created"
    click_on "Back"
  end

  test "updating a Utility file" do
    visit utility_files_url
    click_on "Edit", match: :first

    fill_in "Description", with: @utility_file.description
    fill_in "Filepath", with: @utility_file.filepath
    fill_in "Name", with: @utility_file.name
    click_on "Update Utility file"

    assert_text "Utility file was successfully updated"
    click_on "Back"
  end

  test "destroying a Utility file" do
    visit utility_files_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Utility file was successfully destroyed"
  end
end
