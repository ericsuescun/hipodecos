# == Schema Information
#
# Table name: suggestions
#
#  id          :bigint           not null, primary key
#  inform_id   :bigint
#  user_id     :integer
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  cyto_status :string
#
class Suggestion < ApplicationRecord
  belongs_to :inform

  has_many :objections, as: :objectionable, dependent: :destroy

  default_scope -> { order(created_at: :asc) }

  validates :description, :user_id, presence: true
end
