class Objection < ApplicationRecord
  belongs_to :objectionable, polymorphic: true
end
