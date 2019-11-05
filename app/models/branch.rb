class Branch < ApplicationRecord
  belongs_to :entity

  validates :name, :initials, :code, presence: true
  validates :code, uniqueness: true
end
