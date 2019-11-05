class Rate < ApplicationRecord
	# has_many :factors, dependent: :destroy
	has_many :factors
end
