class Patient < ApplicationRecord
	has_many :informs, dependent: :destroy
	has_many :diganostics, through: :informs
	has_many :physicians
	accepts_nested_attributes_for :informs

	default_scope -> { order(created_at: :desc) }
end
