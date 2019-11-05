class Entity < ApplicationRecord
	# has_many :branches, dependent: :destroy	#Hago dificil la borrada para evitar catástrofes
	has_many :branches


	validates :name, :initials, :code, presence: true
	validates :code, uniqueness: true

end
