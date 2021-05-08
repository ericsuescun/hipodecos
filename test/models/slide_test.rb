# == Schema Information
#
# Table name: slides
#
#  id          :bigint           not null, primary key
#  inform_id   :bigint
#  user_id     :integer
#  slide_tag   :string
#  stored      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#  colored     :boolean          default(FALSE)
#  tagged      :boolean          default(FALSE)
#  covered     :boolean          default(FALSE)
#
require 'test_helper'

class SlideTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
