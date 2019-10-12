require "application_system_test_case"

class EntitiesTest < ApplicationSystemTestCase
  setup do
    @entity = entities(:one)
  end

  test "visiting the index" do
    visit entities_url
    assert_selector "h1", text: "Entities"
  end

  test "creating a Entity" do
    visit entities_url
    click_on "New Entity"

    fill_in "Address", with: @entity.address
    fill_in "Code", with: @entity.code
    fill_in "Department", with: @entity.department
    fill_in "Entype", with: @entity.entype
    fill_in "Initials", with: @entity.initials
    fill_in "Mgr cel", with: @entity.mgr_cel
    fill_in "Mgr email", with: @entity.mgr_email
    fill_in "Mgr name", with: @entity.mgr_name
    fill_in "Mgr tel", with: @entity.mgr_tel
    fill_in "Municipality", with: @entity.municipality
    fill_in "Name", with: @entity.name
    click_on "Create Entity"

    assert_text "Entity was successfully created"
    click_on "Back"
  end

  test "updating a Entity" do
    visit entities_url
    click_on "Edit", match: :first

    fill_in "Address", with: @entity.address
    fill_in "Code", with: @entity.code
    fill_in "Department", with: @entity.department
    fill_in "Entype", with: @entity.entype
    fill_in "Initials", with: @entity.initials
    fill_in "Mgr cel", with: @entity.mgr_cel
    fill_in "Mgr email", with: @entity.mgr_email
    fill_in "Mgr name", with: @entity.mgr_name
    fill_in "Mgr tel", with: @entity.mgr_tel
    fill_in "Municipality", with: @entity.municipality
    fill_in "Name", with: @entity.name
    click_on "Update Entity"

    assert_text "Entity was successfully updated"
    click_on "Back"
  end

  test "destroying a Entity" do
    visit entities_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Entity was successfully destroyed"
  end
end
