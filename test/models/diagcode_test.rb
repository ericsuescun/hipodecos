# == Schema Information
#
# Table name: diagcodes
#
#  id          :bigint           not null, primary key
#  admin_id    :integer
#  organ       :string
#  feature1    :string
#  feature2    :string
#  feature3    :string
#  feature4    :string
#  feature5    :string
#  description :text
#  pss_code    :string
#  who_code    :string
#  score       :decimal(, )
#  order       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  organ_code  :integer
#
require 'test_helper'

class DiagcodeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
