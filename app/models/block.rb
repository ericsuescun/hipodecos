class Block < ApplicationRecord
  belongs_to :inform

  has_many :objections, as: :objectionable, dependent: :destroy
  # has_many :objections, as: :objectionable

  default_scope -> { order(block_tag: :asc) }
  validates :block_tag, uniqueness: true
end
