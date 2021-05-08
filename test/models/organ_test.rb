# == Schema Information
#
# Table name: organs
#
#  id         :bigint           not null, primary key
#  admin_id   :integer
#  organ      :string
#  organ_code :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  part       :string
#
require 'test_helper'

class OrganTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
