class Physician < ApplicationRecord
  belongs_to :inform, optional: true

  has_many :objections, as: :objectionable

  # validates :name, :lastname, presence: true

end
