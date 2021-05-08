# == Schema Information
#
# Table name: roles
#
#  id               :bigint           not null, primary key
#  admin_id         :integer
#  name             :string
#  description      :text
#  rate             :decimal(, )
#  time             :decimal(, )
#  health_care_rate :decimal(, )
#  pension_rate     :decimal(, )
#  parafiscal_rate  :decimal(, )
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Role < ApplicationRecord
	validates :name, :description, :rate, :time, :health_care_rate, :pension_rate, :parafiscal_rate, presence: true
end
