require "application_system_test_case"

class PromotersTest < ApplicationSystemTestCase
  setup do
    @promoter = promoters(:one)
  end

  test "visiting the index" do
    visit promoters_url
    assert_selector "h1", text: "Promoters"
  end

  test "creating a Promoter" do
    visit promoters_url
    click_on "New Promoter"

    fill_in "Code", with: @promoter.code
    fill_in "Initials", with: @promoter.initials
    fill_in "Name", with: @promoter.name
    click_on "Create Promoter"

    assert_text "Promoter was successfully created"
    click_on "Back"
  end

  test "updating a Promoter" do
    visit promoters_url
    click_on "Edit", match: :first

    fill_in "Code", with: @promoter.code
    fill_in "Initials", with: @promoter.initials
    fill_in "Name", with: @promoter.name
    click_on "Update Promoter"

    assert_text "Promoter was successfully updated"
    click_on "Back"
  end

  test "destroying a Promoter" do
    visit promoters_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Promoter was successfully destroyed"
  end
end
