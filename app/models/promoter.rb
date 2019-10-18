class Promoter < ApplicationRecord
	validates :name, :initials, :code, presence: true
	validates :code, uniqueness: true
end
