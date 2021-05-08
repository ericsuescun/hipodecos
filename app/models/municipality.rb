# == Schema Information
#
# Table name: municipalities
#
#  id           :bigint           not null, primary key
#  code         :string
#  municipality :string
#  department   :string
#  order        :integer
#  score        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Municipality < ApplicationRecord
	require 'csv'

	default_scope -> { order(order: :desc, municipality: :asc) }

	def self.import(file)
		CSV.foreach(file.path, :col_sep => (";"), headers: true, encoding: 'iso-8859-1:utf-8') do |row|
			Municipality.create!(row.to_hash)
		end
	end
end
