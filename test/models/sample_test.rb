# == Schema Information
#
# Table name: samples
#
#  id            :bigint           not null, primary key
#  inform_id     :bigint
#  user_id       :integer
#  name          :string
#  description   :text
#  recipient_tag :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  sample_tag    :string
#  organ_code    :string
#  fragment      :integer
#  slide_tag     :string
#  included      :boolean          default(FALSE)
#  blocked       :boolean          default(FALSE)
#
require 'test_helper'

class SampleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
