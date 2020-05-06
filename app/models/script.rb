class Script < ApplicationRecord
  belongs_to :automatic

  default_scope -> { order(script_order: :asc) }
end
