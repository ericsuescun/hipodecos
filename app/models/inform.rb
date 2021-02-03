class Inform < ApplicationRecord
  belongs_to :patient, optional: true

  default_scope -> { order(created_at: :asc) }

  scope :cyto, -> { where(inf_type: 'cito') }
  scope :biop, -> { where("inf_type != 'cito'") }
  scope :hosp, -> { where(inf_type: 'hosp') }
  scope :clin, -> { where(inf_type: 'clin') }
  scope :ready, -> { where(inf_status: 'ready')}

  has_many :samples, dependent: :destroy  #Dificulto el borrado automático para evitar catástrofes
  has_many :studies, dependent: :destroy
  has_many :macros, dependent: :destroy
  has_many :blocks, dependent: :destroy
  has_many :slides, dependent: :destroy
  has_many :micros, dependent: :destroy
  has_many :diagnostics, dependent: :destroy
  has_many :recipients, dependent: :destroy

  has_many :physicians, dependent: :destroy
  accepts_nested_attributes_for :physicians
  
  has_many :cytologies, dependent: :destroy
  accepts_nested_attributes_for :cytologies

  has_many :suggestions, dependent: :destroy

  has_many :pictures, as: :imageable, dependent: :destroy

  has_many :objections, as: :objectionable, dependent: :destroy

  has_many :comments, as: :commentable, dependent: :destroy


  # has_many :samples
  # has_many :studies
  # has_many :macros
  # has_many :blocks
  # has_many :slides
  # has_many :micros
  # has_many :diagnostics
  # has_many :pictures, as: :imageable
  # has_many :recipients
  # has_many :physicians
  # accepts_nested_attributes_for :physicians

  validates :receive_date, :inf_type, presence: true

end
