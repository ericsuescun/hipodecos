class Diagcode < ApplicationRecord

	has_many :autos, dependent: :destroy

	require 'csv'

	def self.import(file)
		CSV.foreach(file.path, :col_sep => (";"), headers: true, encoding: 'iso-8859-1:utf-8') do |row|
			Diagcode.create!(row.to_hash.merge(admin_id: 1))
		end
	end

end
