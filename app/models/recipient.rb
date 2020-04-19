class Recipient < ApplicationRecord
  belongs_to :inform

  has_many :objections, as: :objectionable
end
