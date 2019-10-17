class Promoter < ApplicationRecord
	validates :name, :initials, :code, presence: true
end
