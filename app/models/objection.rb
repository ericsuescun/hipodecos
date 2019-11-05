class Objection < ApplicationRecord
  belongs_to :objectionable, polymorphic: true

  default_scope -> { order(closed: :asc, created_at: :desc) }

  validates :name, presence: true
end
