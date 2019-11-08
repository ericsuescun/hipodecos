class Inform < ApplicationRecord
  belongs_to :patient, optional: true

  default_scope -> { order(receive_date: :desc) }

  # has_many :physicians, dependent: :destroy


  # accepts_nested_attributes_for :physicians, allow_destroy: true

  # has_many :pictures, as: :imageable, dependent: :destroy

  # has_many :samples, dependent: :destroy  #Dificulto el borrado automático para evitar catástrofes
  # has_many :studies, dependent: :destroy
  # has_many :macros, dependent: :destroy
  # has_many :blocks, dependent: :destroy
  # has_many :slides, dependent: :destroy
  # has_many :micros, dependent: :destroy
  # has_many :diagnostics, dependent: :destroy

  has_many :physicians
  accepts_nested_attributes_for :physicians
  has_many :samples
  has_many :studies
  has_many :macros
  has_many :blocks
  has_many :slides
  has_many :micros
  has_many :diagnostics
  has_many :pictures, as: :imageable

  validates :receive_date, :promoter_id, :branch_id, presence: true

end
