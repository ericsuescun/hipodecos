# == Schema Information
#
# Table name: diagnostics
#
#  id          :bigint           not null, primary key
#  inform_id   :bigint
#  user_id     :integer
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  diagcode_id :integer
#  pss_code    :string
#  who_code    :string
#  result      :string
#  cyto_status :string
#
require 'test_helper'

class DiagnosticTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
