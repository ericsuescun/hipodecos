# == Schema Information
#
# Table name: obcodes
#
#  id         :bigint           not null, primary key
#  admin_id   :integer
#  title      :string
#  process    :string
#  score      :decimal(, )
#  order      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Obcode < ApplicationRecord

	require 'csv'

	def self.import(file)
		CSV.foreach(file.path, :col_sep => (";"), headers: true, encoding: 'iso-8859-1:utf-8') do |row|
			Obcode.create!(row.to_hash.merge(admin_id: 1))
		end
	end

end
