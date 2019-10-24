class Inform < ApplicationRecord
  belongs_to :patient

  default_scope -> { order(created_at: :desc) }

  has_many :physicians, dependent: :destroy

  has_many :samples, dependent: :destroy
  has_many :studies, dependent: :destroy
  has_many :macros, dependent: :destroy
  has_many :blocks, dependent: :destroy
  has_many :slides, dependent: :destroy
  has_many :micros, dependent: :destroy
  has_many :diagnostics, dependent: :destroy

end
