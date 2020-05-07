class Automatic < ApplicationRecord
	has_many :scripts, dependent: :destroy

	default_scope -> {order(organ: :asc)}
end
