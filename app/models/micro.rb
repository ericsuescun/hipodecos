class Micro < ApplicationRecord
  belongs_to :inform

  has_many :objections, as: :objectionable, dependent: :destroy
  # has_many :objections, as: :objectionable

  # has_many :pictures, as: :imageable, dependent: :destroy
  has_many :pictures, as: :imageable

  default_scope -> { order(created_at: :desc) }

  validates :description, presence: true
end
