# == Schema Information
#
# Table name: branches
#
#  id           :bigint           not null, primary key
#  entity_id    :bigint
#  name         :string
#  initials     :string
#  code         :string
#  mgr_name     :string
#  mgr_email    :string
#  mgr_tel      :string
#  mgr_cel      :string
#  municipality :string
#  department   :string
#  address      :string
#  entype       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'test_helper'

class BranchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
