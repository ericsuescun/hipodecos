require "application_system_test_case"

class InformsTest < ApplicationSystemTestCase
  setup do
    @inform = informs(:one)
  end

  test "visiting the index" do
    visit informs_url
    assert_selector "h1", text: "Informs"
  end

  test "creating a Inform" do
    visit informs_url
    click_on "New Inform"

    fill_in "Branch", with: @inform.branch_id
    fill_in "Copayment", with: @inform.copayment
    fill_in "Cost", with: @inform.cost
    fill_in "Delivery date", with: @inform.delivery_date
    fill_in "Entity", with: @inform.entity_id
    fill_in "Patient", with: @inform.patient_id
    fill_in "Physician", with: @inform.physician_id
    fill_in "Pregnancy status", with: @inform.pregnancy_status
    fill_in "Price", with: @inform.price
    fill_in "Prmtr auth code", with: @inform.prmtr_auth_code
    fill_in "Promoter", with: @inform.promoter_id
    fill_in "Receive date", with: @inform.receive_date
    fill_in "Regime", with: @inform.regime
    fill_in "Status", with: @inform.status
    fill_in "Tag code", with: @inform.tag_code
    fill_in "User", with: @inform.user_id
    fill_in "User review date", with: @inform.user_review_date
    fill_in "Zone type", with: @inform.zone_type
    click_on "Create Inform"

    assert_text "Inform was successfully created"
    click_on "Back"
  end

  test "updating a Inform" do
    visit informs_url
    click_on "Edit", match: :first

    fill_in "Branch", with: @inform.branch_id
    fill_in "Copayment", with: @inform.copayment
    fill_in "Cost", with: @inform.cost
    fill_in "Delivery date", with: @inform.delivery_date
    fill_in "Entity", with: @inform.entity_id
    fill_in "Patient", with: @inform.patient_id
    fill_in "Physician", with: @inform.physician_id
    fill_in "Pregnancy status", with: @inform.pregnancy_status
    fill_in "Price", with: @inform.price
    fill_in "Prmtr auth code", with: @inform.prmtr_auth_code
    fill_in "Promoter", with: @inform.promoter_id
    fill_in "Receive date", with: @inform.receive_date
    fill_in "Regime", with: @inform.regime
    fill_in "Status", with: @inform.status
    fill_in "Tag code", with: @inform.tag_code
    fill_in "User", with: @inform.user_id
    fill_in "User review date", with: @inform.user_review_date
    fill_in "Zone type", with: @inform.zone_type
    click_on "Update Inform"

    assert_text "Inform was successfully updated"
    click_on "Back"
  end

  test "destroying a Inform" do
    visit informs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Inform was successfully destroyed"
  end
end
