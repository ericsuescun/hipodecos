# == Schema Information
#
# Table name: pictures
#
#  id             :bigint           not null, primary key
#  imageable_type :string
#  imageable_id   :bigint
#  user_id        :integer
#  name           :string
#  description    :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'test_helper'

class PictureTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
