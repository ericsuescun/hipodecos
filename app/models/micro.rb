class Micro < ApplicationRecord
  belongs_to :inform

  has_many :objections, as: :objectionable

  default_scope -> { order(created_at: :desc) }
end
