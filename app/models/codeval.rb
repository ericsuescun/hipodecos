class Codeval < ApplicationRecord

	require 'csv'

	has_many :factors, dependent: :destroy
	has_many :values, dependent: :destroy
	has_many :rates, through: :factors, dependent: :destroy
	has_many :costs, through: :values, dependent: :destroy

	def self.import(file)
		CSV.foreach(file.path, :col_sep => (";"), headers: true, encoding: 'iso-8859-1:utf-8') do |row|
			Codeval.create!(row.to_hash.merge(admin_id: current_admin.id))
		end
	end
end
