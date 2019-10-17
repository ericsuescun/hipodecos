class Entity < ApplicationRecord
	validates :name, :initials, :code, :mgr_name, :mgr_email, :mgr_tel, :mgr_cel, :municipality, :department, :address, :entype, presence: true

	has_many :branches
end
