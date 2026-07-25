# == Schema Information
#
# Table name: rates
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  admin_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  factor      :decimal(, )
#  cost_id     :integer
#
class Rate < ApplicationRecord
	has_many :factors, dependent: :destroy
	# has_many :factors

	validates :name, :description, :factor, presence: true

	# Short label for column headers etc.: initials of each word for multi-word
	# names ("San Vicente Fundación" -> "SVF"), or the first 5 characters for a
	# single-word name ("MEDIMUJER" -> "MEDIM"). The full name is shown as a
	# tooltip wherever the short name appears.
	def short_name
		words = name.to_s.scan(/[[:alpha:]]+/)
		words.size > 1 ? words.map { |word| word[0] }.join.upcase : name.to_s[0, 5].upcase
	end
end
