class Cytology < ApplicationRecord
  belongs_to :inform, optional: true

  has_many :objections, as: :objectionable, dependent: :destroy
  
end
