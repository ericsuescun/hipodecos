class Automatic < ApplicationRecord
	has_many :scripts, dependent: :destroy
end
