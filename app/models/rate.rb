class Rate < ApplicationRecord
	has_many :factors, dependent: :destroy
	# has_many :factors

	validates :name, :description, :factor, presence: true
end
