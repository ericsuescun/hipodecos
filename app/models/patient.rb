class Patient < ApplicationRecord
	has_many :informs, dependent: :destroy
	has_many :diganostics, through: :informs
	has_many :physicians, through: :informs
	accepts_nested_attributes_for :physicians

	default_scope -> { order(created_at: :desc) }
end
