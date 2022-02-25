# == Schema Information
#
# Table name: diagcodes
#
#  id          :bigint           not null, primary key
#  admin_id    :integer
#  organ       :string
#  feature1    :string
#  feature2    :string
#  feature3    :string
#  feature4    :string
#  feature5    :string
#  description :text
#  pss_code    :string
#  who_code    :string
#  score       :decimal(, )
#  order       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  organ_code  :integer
#
class Diagcode < ApplicationRecord
	has_many :autos, dependent: :destroy
	has_many :diagnostics

	require 'csv'

	def self.import(file)
		CSV.foreach(file.path, :col_sep => (";"), headers: true, encoding: 'iso-8859-1:utf-8') do |row|
			Diagcode.create!(row.to_hash.merge(admin_id: 1))
		end
	end

end
