require "application_system_test_case"

class DiagcodesTest < ApplicationSystemTestCase
  setup do
    @diagcode = diagcodes(:one)
  end

  test "visiting the index" do
    visit diagcodes_url
    assert_selector "h1", text: "Diagcodes"
  end

  test "creating a Diagcode" do
    visit diagcodes_url
    click_on "New Diagcode"

    fill_in "Admin", with: @diagcode.admin_id
    fill_in "Description", with: @diagcode.description
    fill_in "Feature1", with: @diagcode.feature1
    fill_in "Feature2", with: @diagcode.feature2
    fill_in "Feature3", with: @diagcode.feature3
    fill_in "Feature4", with: @diagcode.feature4
    fill_in "Feature5", with: @diagcode.feature5
    fill_in "Order", with: @diagcode.order
    fill_in "Organ", with: @diagcode.organ
    fill_in "Pss code", with: @diagcode.pss_code
    fill_in "Score", with: @diagcode.score
    fill_in "Who code", with: @diagcode.who_code
    click_on "Create Diagcode"

    assert_text "Diagcode was successfully created"
    click_on "Back"
  end

  test "updating a Diagcode" do
    visit diagcodes_url
    click_on "Edit", match: :first

    fill_in "Admin", with: @diagcode.admin_id
    fill_in "Description", with: @diagcode.description
    fill_in "Feature1", with: @diagcode.feature1
    fill_in "Feature2", with: @diagcode.feature2
    fill_in "Feature3", with: @diagcode.feature3
    fill_in "Feature4", with: @diagcode.feature4
    fill_in "Feature5", with: @diagcode.feature5
    fill_in "Order", with: @diagcode.order
    fill_in "Organ", with: @diagcode.organ
    fill_in "Pss code", with: @diagcode.pss_code
    fill_in "Score", with: @diagcode.score
    fill_in "Who code", with: @diagcode.who_code
    click_on "Update Diagcode"

    assert_text "Diagcode was successfully updated"
    click_on "Back"
  end

  test "destroying a Diagcode" do
    visit diagcodes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Diagcode was successfully destroyed"
  end
end
