require "application_system_test_case"

class BranchesTest < ApplicationSystemTestCase
  setup do
    @branch = branches(:one)
  end

  test "visiting the index" do
    visit branches_url
    assert_selector "h1", text: "Branches"
  end

  test "creating a Branch" do
    visit branches_url
    click_on "New Branch"

    fill_in "Address", with: @branch.address
    fill_in "Code", with: @branch.code
    fill_in "Department", with: @branch.department
    fill_in "Entity", with: @branch.entity_id
    fill_in "Entype", with: @branch.entype
    fill_in "Initials", with: @branch.initials
    fill_in "Mgr cel", with: @branch.mgr_cel
    fill_in "Mgr email", with: @branch.mgr_email
    fill_in "Mgr name", with: @branch.mgr_name
    fill_in "Mgr tel", with: @branch.mgr_tel
    fill_in "Municipality", with: @branch.municipality
    fill_in "Name", with: @branch.name
    click_on "Create Branch"

    assert_text "Branch was successfully created"
    click_on "Back"
  end

  test "updating a Branch" do
    visit branches_url
    click_on "Edit", match: :first

    fill_in "Address", with: @branch.address
    fill_in "Code", with: @branch.code
    fill_in "Department", with: @branch.department
    fill_in "Entity", with: @branch.entity_id
    fill_in "Entype", with: @branch.entype
    fill_in "Initials", with: @branch.initials
    fill_in "Mgr cel", with: @branch.mgr_cel
    fill_in "Mgr email", with: @branch.mgr_email
    fill_in "Mgr name", with: @branch.mgr_name
    fill_in "Mgr tel", with: @branch.mgr_tel
    fill_in "Municipality", with: @branch.municipality
    fill_in "Name", with: @branch.name
    click_on "Update Branch"

    assert_text "Branch was successfully updated"
    click_on "Back"
  end

  test "destroying a Branch" do
    visit branches_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Branch was successfully destroyed"
  end
end
