class Inform < ApplicationRecord
  belongs_to :patient

  has_many :samples
  has_many :studies
  has_many :macros
  has_many :blocks
  has_many :slides
  has_many :micros
  has_many :diagnostics
  
end
