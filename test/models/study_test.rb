# == Schema Information
#
# Table name: studies
#
#  id                :bigint           not null, primary key
#  inform_id         :bigint
#  user_id           :integer
#  codeval_id        :integer
#  factor            :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  cost              :decimal(, )
#  price             :decimal(, )
#  margin            :decimal(, )
#  price_description :text
#
require 'test_helper'

class StudyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
