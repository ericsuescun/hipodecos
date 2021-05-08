# == Schema Information
#
# Table name: recipients
#
#  id          :bigint           not null, primary key
#  inform_id   :bigint
#  user_id     :integer
#  tag         :string
#  description :text
#  samples     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'test_helper'

class RecipientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
