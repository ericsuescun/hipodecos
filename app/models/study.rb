class Study < ApplicationRecord
  belongs_to :inform

  default_scope -> { order(created_at: :desc) }
end
