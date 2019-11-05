class Value < ApplicationRecord
  belongs_to :codeval
  belongs_to :cost

  validates :description, presence: true
end
