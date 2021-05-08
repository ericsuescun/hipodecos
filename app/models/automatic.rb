# == Schema Information
#
# Table name: automatics
#
#  id         :bigint           not null, primary key
#  organ      :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  auto_type  :string
#  user_id    :integer
#
class Automatic < ApplicationRecord
	has_many :scripts, dependent: :destroy

	default_scope -> {order(organ: :asc)}
end
