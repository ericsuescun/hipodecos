class Entity < ApplicationRecord
	has_many :branches, dependent: :destroy	#Hago dificil la borrada para evitar catástrofes
	# has_many :branches


	validates :name, :initials, :code, :rate_id, presence: true
	validates :code, :initials, uniqueness: true

end
