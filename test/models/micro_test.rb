# == Schema Information
#
# Table name: micros
#
#  id          :bigint           not null, primary key
#  inform_id   :bigint
#  user_id     :integer
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  cyto_status :string
#
require 'test_helper'

class MicroTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
