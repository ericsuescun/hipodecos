# == Schema Information
#
# Table name: citocodes
#
#  id          :bigint           not null, primary key
#  admin_id    :integer
#  cito_code   :string
#  description :text
#  result_type :string
#  score       :decimal(, )
#  order       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'test_helper'

class CitocodeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
