# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  first_name             :string
#  last_name              :string
#  email2                 :string
#  tel                    :string
#  cel                    :string
#  birth_date             :date
#  join_date              :date
#  active                 :boolean
#  deactivation_date      :date
#  last_admin_id          :integer
#  notes                  :text
#  role_id                :integer
#  file_id                :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  address                :string
#  emergency_contact      :string
#  emergency_tel          :string
#  emergency_cel          :string
#  cvfile                 :string
#  signfile               :string
#  contract               :string
#
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
