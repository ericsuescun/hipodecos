require "application_system_test_case"

class AutosTest < ApplicationSystemTestCase
  setup do
    @auto = autos(:one)
  end

  test "visiting the index" do
    visit autos_url
    assert_selector "h1", text: "Autos"
  end

  test "creating a Auto" do
    visit autos_url
    click_on "New Auto"

    fill_in "Admin", with: @auto.admin_id
    fill_in "Body", with: @auto.body
    fill_in "Dx table", with: @auto.dx_table_id
    fill_in "Param1", with: @auto.param1
    fill_in "Param2", with: @auto.param2
    fill_in "Param3", with: @auto.param3
    fill_in "Param4", with: @auto.param4
    fill_in "Title", with: @auto.title
    fill_in "User", with: @auto.user_id
    click_on "Create Auto"

    assert_text "Auto was successfully created"
    click_on "Back"
  end

  test "updating a Auto" do
    visit autos_url
    click_on "Edit", match: :first

    fill_in "Admin", with: @auto.admin_id
    fill_in "Body", with: @auto.body
    fill_in "Dx table", with: @auto.dx_table_id
    fill_in "Param1", with: @auto.param1
    fill_in "Param2", with: @auto.param2
    fill_in "Param3", with: @auto.param3
    fill_in "Param4", with: @auto.param4
    fill_in "Title", with: @auto.title
    fill_in "User", with: @auto.user_id
    click_on "Update Auto"

    assert_text "Auto was successfully updated"
    click_on "Back"
  end

  test "destroying a Auto" do
    visit autos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Auto was successfully destroyed"
  end
end
