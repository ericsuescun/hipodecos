# == Schema Information
#
# Table name: costs
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  admin_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  base        :integer
#  factor      :decimal(, )
#
require 'test_helper'

class CostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
