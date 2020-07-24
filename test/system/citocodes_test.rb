require "application_system_test_case"

class CitocodesTest < ApplicationSystemTestCase
  setup do
    @citocode = citocodes(:one)
  end

  test "visiting the index" do
    visit citocodes_url
    assert_selector "h1", text: "Citocodes"
  end

  test "creating a Citocode" do
    visit citocodes_url
    click_on "New Citocode"

    fill_in "Admin", with: @citocode.admin_id
    fill_in "Cito code", with: @citocode.cito_code
    fill_in "Description", with: @citocode.description
    fill_in "Order", with: @citocode.order
    fill_in "Result type", with: @citocode.result_type
    fill_in "Score", with: @citocode.score
    click_on "Create Citocode"

    assert_text "Citocode was successfully created"
    click_on "Back"
  end

  test "updating a Citocode" do
    visit citocodes_url
    click_on "Edit", match: :first

    fill_in "Admin", with: @citocode.admin_id
    fill_in "Cito code", with: @citocode.cito_code
    fill_in "Description", with: @citocode.description
    fill_in "Order", with: @citocode.order
    fill_in "Result type", with: @citocode.result_type
    fill_in "Score", with: @citocode.score
    click_on "Update Citocode"

    assert_text "Citocode was successfully updated"
    click_on "Back"
  end

  test "destroying a Citocode" do
    visit citocodes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Citocode was successfully destroyed"
  end
end
