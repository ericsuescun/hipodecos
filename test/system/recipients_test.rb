require "application_system_test_case"

class RecipientsTest < ApplicationSystemTestCase
  setup do
    @recipient = recipients(:one)
  end

  test "visiting the index" do
    visit recipients_url
    assert_selector "h1", text: "Recipients"
  end

  test "creating a Recipient" do
    visit recipients_url
    click_on "New Recipient"

    fill_in "Description", with: @recipient.description
    fill_in "Inform", with: @recipient.inform_id
    fill_in "Samples", with: @recipient.samples
    fill_in "Tag", with: @recipient.tag
    fill_in "User", with: @recipient.user_id
    click_on "Create Recipient"

    assert_text "Recipient was successfully created"
    click_on "Back"
  end

  test "updating a Recipient" do
    visit recipients_url
    click_on "Edit", match: :first

    fill_in "Description", with: @recipient.description
    fill_in "Inform", with: @recipient.inform_id
    fill_in "Samples", with: @recipient.samples
    fill_in "Tag", with: @recipient.tag
    fill_in "User", with: @recipient.user_id
    click_on "Update Recipient"

    assert_text "Recipient was successfully updated"
    click_on "Back"
  end

  test "destroying a Recipient" do
    visit recipients_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Recipient was successfully destroyed"
  end
end
