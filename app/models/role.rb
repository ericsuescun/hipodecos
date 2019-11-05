class Role < ApplicationRecord
	validates :name, :description, :rate, :time, :health_care_rate, :pension_rate, :parafiscal_rate, presence: true
end
