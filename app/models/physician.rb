class Physician < ApplicationRecord
  belongs_to :inform, optional: true

  # has_many :objections, as: :objectionable
  has_many :objections, as: :objectionable, dependent: :destroy

  # validates :name, :lastname, presence: true

end
