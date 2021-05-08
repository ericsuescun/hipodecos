# == Schema Information
#
# Table name: costs
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  admin_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  base        :integer
#  factor      :decimal(, )
#
class Cost < ApplicationRecord
	has_many :values, dependent: :destroy		#Se harán difíciles de borrar para evitar catástrofes
	# has_many :values

	validates :name, :description, :factor, presence: true
end
