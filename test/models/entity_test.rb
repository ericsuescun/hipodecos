# == Schema Information
#
# Table name: entities
#
#  id           :bigint           not null, primary key
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
#  cost_id      :integer
#  rate_id      :integer
#  tax_id       :string
#
require 'test_helper'

class EntityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
