class Physician < ApplicationRecord
  belongs_to :inform, optional: true

end
