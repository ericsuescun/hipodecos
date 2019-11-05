class Codeval < ApplicationRecord

	require 'csv'

	# has_many :factors, dependent: :destroy	#Se harán dificiles de borrar para evitar catástrofes
	has_many :factors

	# has_many :values, dependent: :destroy
	has_many :values

	# has_many :rates, through: :factors, dependent: :destroy
	has_many :rates, through: :factors

	# has_many :costs, through: :values, dependent: :destroy
	has_many :costs, through: :values

	validates :code, :name, :description, presence: true

	def self.import(file)
		CSV.foreach(file.path, :col_sep => (";"), headers: true, encoding: 'iso-8859-1:utf-8') do |row|
			Codeval.create!(row.to_hash.merge(admin_id: 1))
		end
	end
end
