class Slide < ApplicationRecord
  belongs_to :inform

  # has_many :objections, as: :objectionable, dependent: :destroy
  has_many :objections, as: :objectionable

  default_scope -> { order(slide_tag: :asc) }
end
