class Cost < ApplicationRecord
	has_many :values, dependent: :destroy
end
