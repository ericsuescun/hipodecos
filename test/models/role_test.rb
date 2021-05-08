# == Schema Information
#
# Table name: roles
#
#  id               :bigint           not null, primary key
#  admin_id         :integer
#  name             :string
#  description      :text
#  rate             :decimal(, )
#  time             :decimal(, )
#  health_care_rate :decimal(, )
#  pension_rate     :decimal(, )
#  parafiscal_rate  :decimal(, )
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
