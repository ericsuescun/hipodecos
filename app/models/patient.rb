class Patient < ApplicationRecord
	has_many :informs, dependent: :destroy
	has_many :diganostics, through: :informs
	
	accepts_nested_attributes_for :informs, allow_destroy: true

	default_scope -> { order(created_at: :desc) }

	validates :id_number, uniqueness: true
end
