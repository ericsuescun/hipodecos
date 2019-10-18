class Codeval < ApplicationRecord
	has_many :factors
	has_many :values
	has_many :rates, through: :factors
	has_many :costs, through: :values
end
