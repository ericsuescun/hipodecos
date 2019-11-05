class Cost < ApplicationRecord
	# has_many :values, dependent: :destroy		#Se harán difíciles de borrar para evitar catástrofes
	has_many :values
end
