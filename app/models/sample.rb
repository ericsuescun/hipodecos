class Sample < ApplicationRecord
  belongs_to :inform

  # has_many :objections, as: :objectionable, dependent: :destroy
  has_many :objections, as: :objectionable

  has_many :pictures, as: :imageable

  default_scope -> { order(created_at: :desc) }

  validates :name, presence: true
end
