class Patient < ApplicationRecord
	# has_many :informs, dependent: :destroy

	devise :database_authenticatable, :timeoutable,
	       :rememberable, :authentication_keys => [:id_number]

	has_many :informs

	has_many :diganostics, through: :informs
	
	# accepts_nested_attributes_for :informs, allow_destroy: true
	accepts_nested_attributes_for :informs

	default_scope -> { order(created_at: :desc) }

	validates :id_type, :age_number, :age_type, :name1, :lastname1, :sex, presence: true

	validates :id_number, uniqueness: true
end
