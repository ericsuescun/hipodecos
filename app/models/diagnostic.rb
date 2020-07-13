class Diagnostic < ApplicationRecord
  belongs_to :inform

  has_many :objections, as: :objectionable, dependent: :destroy

  default_scope -> { order(created_at: :asc) }

  # validates :description, presence: true
  
end
