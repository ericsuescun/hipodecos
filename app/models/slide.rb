class Slide < ApplicationRecord
  belongs_to :inform

  has_many :objections, as: :objectionable, dependent: :destroy

  default_scope -> { order(created_at: :desc) }
end
