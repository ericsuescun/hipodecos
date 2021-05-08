# == Schema Information
#
# Table name: promoters
#
#  id         :bigint           not null, primary key
#  name       :string
#  initials   :string
#  code       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  regime     :string
#  enabled    :boolean
#
class Promoter < ApplicationRecord
	validates :name, :initials, :code, presence: true
	validates :code, uniqueness: true

	default_scope -> { order(initials: :asc)}

	def self.import(file)
		CSV.foreach(file.path, :col_sep => (";"), headers: true, encoding: 'iso-8859-1:utf-8') do |row|
			Promoter.create!(row.to_hash)
		end
	end
end
