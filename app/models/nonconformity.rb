class Nonconformity < ApplicationRecord
  belongs_to :nonconformitable, polymorphic: true
end
