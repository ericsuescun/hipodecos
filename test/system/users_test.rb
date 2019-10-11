require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test "visiting the index" do
    visit users_url
    assert_selector "h1", text: "Users"
  end

  test "creating a User" do
    visit users_url
    click_on "New User"

    check "Active" if @user.active
    fill_in "Birth date", with: @user.birth_date
    fill_in "Cel", with: @user.cel
    fill_in "Deactivation date", with: @user.deactivation_date
    fill_in "Email2", with: @user.email2
    fill_in "File", with: @user.file_id
    fill_in "First name", with: @user.first_name
    fill_in "Join date", with: @user.join_date
    fill_in "Last admin", with: @user.last_admin_id
    fill_in "Last name", with: @user.last_name
    fill_in "Notes", with: @user.notes
    fill_in "Role", with: @user.role_id
    fill_in "Tel", with: @user.tel
    click_on "Create User"

    assert_text "User was successfully created"
    click_on "Back"
  end

  test "updating a User" do
    visit users_url
    click_on "Edit", match: :first

    check "Active" if @user.active
    fill_in "Birth date", with: @user.birth_date
    fill_in "Cel", with: @user.cel
    fill_in "Deactivation date", with: @user.deactivation_date
    fill_in "Email2", with: @user.email2
    fill_in "File", with: @user.file_id
    fill_in "First name", with: @user.first_name
    fill_in "Join date", with: @user.join_date
    fill_in "Last admin", with: @user.last_admin_id
    fill_in "Last name", with: @user.last_name
    fill_in "Notes", with: @user.notes
    fill_in "Role", with: @user.role_id
    fill_in "Tel", with: @user.tel
    click_on "Update User"

    assert_text "User was successfully updated"
    click_on "Back"
  end

  test "destroying a User" do
    visit users_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User was successfully destroyed"
  end
end
