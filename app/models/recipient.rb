class Recipient < ApplicationRecord
  belongs_to :inform

  default_scope -> { order(tag: :asc)}

  has_many :objections, as: :objectionable
end
