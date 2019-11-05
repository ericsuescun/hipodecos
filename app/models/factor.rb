class Factor < ApplicationRecord
  belongs_to :codeval
  belongs_to :rate

  validates :description, presence: true
end
