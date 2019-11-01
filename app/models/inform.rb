class Inform < ApplicationRecord
  belongs_to :patient, optional: true

  default_scope -> { order(created_at: :desc) }

  has_many :physicians, dependent: :destroy
  accepts_nested_attributes_for :physicians, allow_destroy: true

  has_many :pictures, as: :imageable, dependent: :destroy

  has_many :samples, dependent: :destroy
  has_many :studies, dependent: :destroy
  has_many :macros, dependent: :destroy
  has_many :blocks, dependent: :destroy
  has_many :slides, dependent: :destroy
  has_many :micros, dependent: :destroy
  has_many :diagnostics, dependent: :destroy

end
