require "application_system_test_case"

class FactorsTest < ApplicationSystemTestCase
  setup do
    @factor = factors(:one)
  end

  test "visiting the index" do
    visit factors_url
    assert_selector "h1", text: "Factors"
  end

  test "creating a Factor" do
    visit factors_url
    click_on "New Factor"

    fill_in "Admin", with: @factor.admin_id
    fill_in "Codeval", with: @factor.codeval_id
    fill_in "Description", with: @factor.description
    fill_in "Factor", with: @factor.factor
    fill_in "Rate", with: @factor.rate_id
    click_on "Create Factor"

    assert_text "Factor was successfully created"
    click_on "Back"
  end

  test "updating a Factor" do
    visit factors_url
    click_on "Edit", match: :first

    fill_in "Admin", with: @factor.admin_id
    fill_in "Codeval", with: @factor.codeval_id
    fill_in "Description", with: @factor.description
    fill_in "Factor", with: @factor.factor
    fill_in "Rate", with: @factor.rate_id
    click_on "Update Factor"

    assert_text "Factor was successfully updated"
    click_on "Back"
  end

  test "destroying a Factor" do
    visit factors_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Factor was successfully destroyed"
  end
end
