# == Schema Information
#
# Table name: autos
#
#  id          :bigint           not null, primary key
#  diagcode_id :bigint
#  user_id     :integer
#  admin_id    :integer
#  title       :string
#  body        :text
#  param1      :string
#  param2      :string
#  param3      :string
#  param4      :string
#  param5      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Auto < ApplicationRecord
  belongs_to :diagcode
end
