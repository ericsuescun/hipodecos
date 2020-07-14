class Study < ApplicationRecord
  belongs_to :inform

  has_many :objections, as: :objectionable, dependent: :destroy
  # has_many :objections, as: :objectionable

  default_scope -> { order(created_at: :asc) }

  validates :codeval_id, :factor, presence: true
end
