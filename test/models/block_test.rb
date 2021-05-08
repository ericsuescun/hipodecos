# == Schema Information
#
# Table name: blocks
#
#  id          :bigint           not null, primary key
#  inform_id   :bigint
#  user_id     :integer
#  block_tag   :string
#  stored      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#  organ_code  :string
#  fragment    :integer
#  slide_tag   :string
#  verified    :boolean          default(FALSE)
#
require 'test_helper'

class BlockTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
