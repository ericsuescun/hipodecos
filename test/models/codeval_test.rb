# == Schema Information
#
# Table name: codevals
#
#  id            :bigint           not null, primary key
#  name          :string
#  code          :string
#  description   :text
#  origin_system :string
#  ref_code      :string
#  admin_id      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'test_helper'

class CodevalTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
