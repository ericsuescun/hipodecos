class Codeval < ApplicationRecord
	has_many :factors, dependent: :destroy
	has_many :values, dependent: :destroy
	has_many :rates, through: :factors, dependent: :destroy
	has_many :costs, through: :values, dependent: :destroy
end
