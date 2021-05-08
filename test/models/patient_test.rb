# == Schema Information
#
# Table name: patients
#
#  id                     :bigint           not null, primary key
#  id_number              :string
#  id_type                :string
#  birth_date             :date
#  age_number             :integer
#  age_type               :string
#  name1                  :string
#  name2                  :string
#  lastname1              :string
#  lastname2              :string
#  sex                    :string
#  gender                 :string
#  address                :string
#  email                  :string           default(""), not null
#  tel                    :string
#  cel                    :string
#  occupation             :string
#  residence_code         :string
#  municipality           :string
#  department             :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#
require 'test_helper'

class PatientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
