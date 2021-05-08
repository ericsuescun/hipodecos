# == Schema Information
#
# Table name: rates
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  admin_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  factor      :decimal(, )
#  cost_id     :integer
#
class Rate < ApplicationRecord
	has_many :factors, dependent: :destroy
	# has_many :factors

	validates :name, :description, :factor, presence: true
end
