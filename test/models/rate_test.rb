# == Schema Information
#
# Table name: rates
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  admin_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  factor      :decimal(, )
#  cost_id     :integer
#
require 'test_helper'

class RateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
