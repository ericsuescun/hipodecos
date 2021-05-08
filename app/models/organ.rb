# == Schema Information
#
# Table name: organs
#
#  id         :bigint           not null, primary key
#  admin_id   :integer
#  organ      :string
#  organ_code :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  part       :string
#
class Organ < ApplicationRecord
	require 'csv'

	default_scope -> { order(created_at: :asc) }

	def self.import(file)
		CSV.foreach(file.path, :col_sep => (";"), headers: true, encoding: 'iso-8859-1:utf-8') do |row|
			Organ.create!(row.to_hash.merge(admin_id: 1))
		end
	end
end
