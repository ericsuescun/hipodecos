# == Schema Information
#
# Table name: macros
#
#  id          :bigint           not null, primary key
#  inform_id   :bigint
#  user_id     :integer
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'test_helper'

class MacroTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
