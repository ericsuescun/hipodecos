require "application_system_test_case"

class PatientsTest < ApplicationSystemTestCase
  setup do
    @patient = patients(:one)
  end

  test "visiting the index" do
    visit patients_url
    assert_selector "h1", text: "Patients"
  end

  test "creating a Patient" do
    visit patients_url
    click_on "New Patient"

    fill_in "Address", with: @patient.address
    fill_in "Age number", with: @patient.age_number
    fill_in "Age type", with: @patient.age_type
    fill_in "Birth date", with: @patient.birth_date
    fill_in "Cel", with: @patient.cel
    fill_in "Department", with: @patient.department
    fill_in "Email", with: @patient.email
    fill_in "Gender", with: @patient.gender
    fill_in "Id number", with: @patient.id_number
    fill_in "Id type", with: @patient.id_type
    fill_in "Lastname1", with: @patient.lastname1
    fill_in "Lastname2", with: @patient.lastname2
    fill_in "Municipality", with: @patient.municipality
    fill_in "Name1", with: @patient.name1
    fill_in "Name2", with: @patient.name2
    fill_in "Occupation", with: @patient.occupation
    fill_in "Residence code", with: @patient.residence_code
    fill_in "Sex", with: @patient.sex
    fill_in "Tel", with: @patient.tel
    click_on "Create Patient"

    assert_text "Patient was successfully created"
    click_on "Back"
  end

  test "updating a Patient" do
    visit patients_url
    click_on "Edit", match: :first

    fill_in "Address", with: @patient.address
    fill_in "Age number", with: @patient.age_number
    fill_in "Age type", with: @patient.age_type
    fill_in "Birth date", with: @patient.birth_date
    fill_in "Cel", with: @patient.cel
    fill_in "Department", with: @patient.department
    fill_in "Email", with: @patient.email
    fill_in "Gender", with: @patient.gender
    fill_in "Id number", with: @patient.id_number
    fill_in "Id type", with: @patient.id_type
    fill_in "Lastname1", with: @patient.lastname1
    fill_in "Lastname2", with: @patient.lastname2
    fill_in "Municipality", with: @patient.municipality
    fill_in "Name1", with: @patient.name1
    fill_in "Name2", with: @patient.name2
    fill_in "Occupation", with: @patient.occupation
    fill_in "Residence code", with: @patient.residence_code
    fill_in "Sex", with: @patient.sex
    fill_in "Tel", with: @patient.tel
    click_on "Update Patient"

    assert_text "Patient was successfully updated"
    click_on "Back"
  end

  test "destroying a Patient" do
    visit patients_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Patient was successfully destroyed"
  end
end
