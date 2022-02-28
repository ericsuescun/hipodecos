# == Schema Information
#
# Table name: branches
#
#  id           :bigint           not null, primary key
#  entity_id    :bigint
#  name         :string
#  initials     :string
#  code         :string
#  mgr_name     :string
#  mgr_email    :string
#  mgr_tel      :string
#  mgr_cel      :string
#  municipality :string
#  department   :string
#  address      :string
#  entype       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Branch < ApplicationRecord
  belongs_to :entity

  validates :name, :initials, presence: true
  

  default_scope -> { order(initials: :asc) }

  def self.import(file)
  	CSV.foreach(file.path, :col_sep => (";"), headers: true, encoding: 'iso-8859-1:utf-8') do |row|
  		Branch.create!(row.to_hash)
  	end
  end

end
