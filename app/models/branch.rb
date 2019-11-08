class Branch < ApplicationRecord
  belongs_to :entity

  validates :name, :initials, :code, presence: true
  validates :code, uniqueness: true

  def self.import(file)
  	CSV.foreach(file.path, :col_sep => (";"), headers: true, encoding: 'iso-8859-1:utf-8') do |row|
  		Branch.create!(row.to_hash)
  	end
  end

end
