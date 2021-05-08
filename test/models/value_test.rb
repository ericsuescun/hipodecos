# == Schema Information
#
# Table name: values
#
#  id          :bigint           not null, primary key
#  codeval_id  :bigint
#  cost_id     :bigint
#  value       :decimal(, )
#  description :text
#  admin_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'test_helper'

class ValueTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
