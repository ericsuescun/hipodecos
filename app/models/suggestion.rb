class Suggestion < ApplicationRecord
  belongs_to :inform

  has_many :objections, as: :objectionable, dependent: :destroy

  default_scope -> { order(created_at: :asc) }

  validates :description, :user_id, presence: true
end
