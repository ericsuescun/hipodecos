class Physician < ApplicationRecord
  belongs_to :inform

  validates :name, :lastname, presence: true
end
