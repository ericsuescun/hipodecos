class Rate < ApplicationRecord
	has_many :factors, dependent: :destroy
end
