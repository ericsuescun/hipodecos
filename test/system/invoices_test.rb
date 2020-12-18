require "application_system_test_case"

class InvoicesTest < ApplicationSystemTestCase
  setup do
    @invoice = invoices(:one)
  end

  test "visiting the index" do
    visit invoices_url
    assert_selector "h1", text: "Invoices"
  end

  test "creating a Invoice" do
    visit invoices_url
    click_on "New Invoice"

    fill_in "Entity", with: @invoice.entity_id
    fill_in "Final date", with: @invoice.final_date
    fill_in "Inf type", with: @invoice.inf_type
    fill_in "Init date", with: @invoice.init_date
    fill_in "Invoice code", with: @invoice.invoice_code
    fill_in "Invoice date", with: @invoice.invoice_date
    fill_in "User", with: @invoice.user_id
    fill_in "Value", with: @invoice.value
    click_on "Create Invoice"

    assert_text "Invoice was successfully created"
    click_on "Back"
  end

  test "updating a Invoice" do
    visit invoices_url
    click_on "Edit", match: :first

    fill_in "Entity", with: @invoice.entity_id
    fill_in "Final date", with: @invoice.final_date
    fill_in "Inf type", with: @invoice.inf_type
    fill_in "Init date", with: @invoice.init_date
    fill_in "Invoice code", with: @invoice.invoice_code
    fill_in "Invoice date", with: @invoice.invoice_date
    fill_in "User", with: @invoice.user_id
    fill_in "Value", with: @invoice.value
    click_on "Update Invoice"

    assert_text "Invoice was successfully updated"
    click_on "Back"
  end

  test "destroying a Invoice" do
    visit invoices_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Invoice was successfully destroyed"
  end
end
