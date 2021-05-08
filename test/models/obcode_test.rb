# == Schema Information
#
# Table name: obcodes
#
#  id         :bigint           not null, primary key
#  admin_id   :integer
#  title      :string
#  process    :string
#  score      :decimal(, )
#  order      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class ObcodeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
