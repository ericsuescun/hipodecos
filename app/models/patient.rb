class Patient < ApplicationRecord
	# has_many :informs, dependent: :destroy
	has_many :informs

	has_many :diganostics, through: :informs
	
	# accepts_nested_attributes_for :informs, allow_destroy: true
	accepts_nested_attributes_for :informs

	default_scope -> { order(created_at: :desc) }

	validates :id_number, uniqueness: true
end
