# == Schema Information
#
# Table name: municipalities
#
#  id           :bigint           not null, primary key
#  code         :string
#  municipality :string
#  department   :string
#  order        :integer
#  score        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'test_helper'

class MunicipalityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
