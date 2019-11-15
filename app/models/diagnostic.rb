class Diagnostic < ApplicationRecord
  belongs_to :inform

  # has_many :objections, as: :objectionable, dependent: :destroy
  has_many :objections, as: :objectionable	#No se borarán las No Conformidades en caso de borrarse un diagnóstico de manera automática

  default_scope -> { order(created_at: :desc) }

  # validates :description, presence: true
  
end
