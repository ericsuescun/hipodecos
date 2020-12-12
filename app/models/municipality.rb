class Municipality < ApplicationRecord
	require 'csv'

	default_scope -> { order(order: :desc, municipality: :asc) }

	def self.import(file)
		CSV.foreach(file.path, :col_sep => (";"), headers: true, encoding: 'iso-8859-1:utf-8') do |row|
			Municipality.create!(row.to_hash)
		end
	end
end
