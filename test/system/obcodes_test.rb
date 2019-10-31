require "application_system_test_case"

class ObcodesTest < ApplicationSystemTestCase
  setup do
    @obcode = obcodes(:one)
  end

  test "visiting the index" do
    visit obcodes_url
    assert_selector "h1", text: "Obcodes"
  end

  test "creating a Obcode" do
    visit obcodes_url
    click_on "New Obcode"

    fill_in "Admin", with: @obcode.admin_id
    fill_in "Order", with: @obcode.order
    fill_in "Process", with: @obcode.process
    fill_in "Score", with: @obcode.score
    fill_in "Title", with: @obcode.title
    click_on "Create Obcode"

    assert_text "Obcode was successfully created"
    click_on "Back"
  end

  test "updating a Obcode" do
    visit obcodes_url
    click_on "Edit", match: :first

    fill_in "Admin", with: @obcode.admin_id
    fill_in "Order", with: @obcode.order
    fill_in "Process", with: @obcode.process
    fill_in "Score", with: @obcode.score
    fill_in "Title", with: @obcode.title
    click_on "Update Obcode"

    assert_text "Obcode was successfully updated"
    click_on "Back"
  end

  test "destroying a Obcode" do
    visit obcodes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Obcode was successfully destroyed"
  end
end
