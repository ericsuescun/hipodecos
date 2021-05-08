# == Schema Information
#
# Table name: promoters
#
#  id         :bigint           not null, primary key
#  name       :string
#  initials   :string
#  code       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  regime     :string
#  enabled    :boolean
#
require 'test_helper'

class PromoterTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
