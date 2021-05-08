# == Schema Information
#
# Table name: objections
#
#  id                  :bigint           not null, primary key
#  objectionable_type  :string
#  objectionable_id    :bigint
#  user_id             :integer
#  obcode_id           :integer
#  responsible_user_id :integer
#  close_user_id       :integer
#  close_date          :date
#  description         :text
#  closed              :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require 'test_helper'

class ObjectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
