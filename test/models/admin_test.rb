# == Schema Information
#
# Table name: admins
#
#  id                     :bigint           not null, primary key
#  name                   :string
#  tel                    :string
#  cel                    :string
#  address                :string
#  god_mode               :boolean
#  reports_only           :boolean
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#
require 'test_helper'

class AdminTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
