class Inform < ApplicationRecord
  belongs_to :patient
  has_many :samples
  has_many :studies
end
