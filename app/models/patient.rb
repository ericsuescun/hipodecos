class Patient < ApplicationRecord
	has_many :informs, dependent: :destroy
	has_many :diganostics, through: :informs

	default_scope -> { order(created_at: :desc) }
end
