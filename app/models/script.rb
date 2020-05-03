class Script < ApplicationRecord
  belongs_to :template

  default_scope -> { order(script_order: :asc) }
end
