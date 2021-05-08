# == Schema Information
#
# Table name: automatics
#
#  id         :bigint           not null, primary key
#  organ      :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  auto_type  :string
#  user_id    :integer
#
require 'test_helper'

class AutomaticTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
