require 'test_helper'

class PatientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @patient = patients(:one)
  end

  test "should get index" do
    get patients_url
    assert_response :success
  end

  test "should get new" do
    get new_patient_url
    assert_response :success
  end

  test "should create patient" do
    assert_difference('Patient.count') do
      post patients_url, params: { patient: { address: @patient.address, age_number: @patient.age_number, age_type: @patient.age_type, birth_date: @patient.birth_date, cel: @patient.cel, department: @patient.department, email: @patient.email, gender: @patient.gender, id_number: @patient.id_number, id_type: @patient.id_type, lastname1: @patient.lastname1, lastname2: @patient.lastname2, municipality: @patient.municipality, name1: @patient.name1, name2: @patient.name2, occupation: @patient.occupation, residence_code: @patient.residence_code, sex: @patient.sex, tel: @patient.tel } }
    end

    assert_redirected_to patient_url(Patient.last)
  end

  test "should show patient" do
    get patient_url(@patient)
    assert_response :success
  end

  test "should get edit" do
    get edit_patient_url(@patient)
    assert_response :success
  end

  test "should update patient" do
    patch patient_url(@patient), params: { patient: { address: @patient.address, age_number: @patient.age_number, age_type: @patient.age_type, birth_date: @patient.birth_date, cel: @patient.cel, department: @patient.department, email: @patient.email, gender: @patient.gender, id_number: @patient.id_number, id_type: @patient.id_type, lastname1: @patient.lastname1, lastname2: @patient.lastname2, municipality: @patient.municipality, name1: @patient.name1, name2: @patient.name2, occupation: @patient.occupation, residence_code: @patient.residence_code, sex: @patient.sex, tel: @patient.tel } }
    assert_redirected_to patient_url(@patient)
  end

  test "should destroy patient" do
    assert_difference('Patient.count', -1) do
      delete patient_url(@patient)
    end

    assert_redirected_to patients_url
  end
end
