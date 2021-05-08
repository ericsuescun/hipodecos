# == Schema Information
#
# Table name: citocodes
#
#  id          :bigint           not null, primary key
#  admin_id    :integer
#  cito_code   :string
#  description :text
#  result_type :string
#  score       :decimal(, )
#  order       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Citocode < ApplicationRecord

	require 'csv'
	
	def self.import(file)
		CSV.foreach(file.path, :col_sep => (";"), headers: true, encoding: 'iso-8859-1:utf-8') do |row|
			Citocode.create!(row.to_hash.merge(admin_id: 1))
		end
	end
end
