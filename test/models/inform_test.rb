# == Schema Information
#
# Table name: informs
#
#  id                       :bigint           not null, primary key
#  patient_id               :bigint
#  user_id                  :integer
#  physician_id             :integer
#  tag_code                 :string
#  receive_date             :date
#  delivery_date            :datetime
#  user_review_date         :date
#  prmtr_auth_code          :string
#  zone_type                :string
#  pregnancy_status         :string
#  status                   :string
#  regime                   :string
#  promoter_id              :integer
#  entity_id                :integer
#  branch_id                :integer
#  copayment                :decimal(, )
#  cost                     :decimal(, )
#  price                    :decimal(, )
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  invoice                  :string
#  inf_status               :string
#  pathologist_id           :integer
#  pathologist_review_id    :integer
#  administrative_review_id :integer
#  p_age                    :integer
#  p_age_type               :string
#  p_address                :string
#  p_email                  :string
#  p_tel                    :string
#  p_cel                    :string
#  p_occupation             :string
#  p_residence_code         :string
#  p_municipality           :string
#  p_department             :string
#  inf_type                 :string
#  cytologist               :integer
#  download_date            :datetime
#  invoice_date             :date
#
require 'test_helper'

class InformTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
