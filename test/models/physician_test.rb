# == Schema Information
#
# Table name: physicians
#
#  id         :bigint           not null, primary key
#  inform_id  :bigint
#  user_id    :integer
#  name       :string
#  lastname   :string
#  tel        :string
#  cel        :string
#  email      :string
#  study1     :string
#  study2     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class PhysicianTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
