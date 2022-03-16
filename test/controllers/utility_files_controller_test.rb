require 'test_helper'

class UtilityFilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @utility_file = utility_files(:one)
  end

  test "should get index" do
    get utility_files_url
    assert_response :success
  end

  test "should get new" do
    get new_utility_file_url
    assert_response :success
  end

  test "should create utility_file" do
    assert_difference('UtilityFile.count') do
      post utility_files_url, params: { utility_file: { description: @utility_file.description, filepath: @utility_file.filepath, name: @utility_file.name } }
    end

    assert_redirected_to utility_file_url(UtilityFile.last)
  end

  test "should show utility_file" do
    get utility_file_url(@utility_file)
    assert_response :success
  end

  test "should get edit" do
    get edit_utility_file_url(@utility_file)
    assert_response :success
  end

  test "should update utility_file" do
    patch utility_file_url(@utility_file), params: { utility_file: { description: @utility_file.description, filepath: @utility_file.filepath, name: @utility_file.name } }
    assert_redirected_to utility_file_url(@utility_file)
  end

  test "should destroy utility_file" do
    assert_difference('UtilityFile.count', -1) do
      delete utility_file_url(@utility_file)
    end

    assert_redirected_to utility_files_url
  end
end
