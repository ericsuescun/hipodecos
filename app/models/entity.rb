class Entity < ApplicationRecord
	has_many :branches

	validates :name, :initials, :code, :mgr_name, :mgr_email, :mgr_tel, :mgr_cel, :municipality, :department, :address, :entype, presence: true
	validates :code, uniqueness: true

end
