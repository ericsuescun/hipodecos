class Micro < ApplicationRecord
  belongs_to :inform

  has_many :objections, as: :objectionable, dependent: :destroy

  has_many :pictures, as: :imageable, dependent: :destroy

  default_scope -> { order(created_at: :desc) }
end
