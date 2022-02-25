# == Schema Information
#
# Table name: diagnostics
#
#  id          :bigint           not null, primary key
#  inform_id   :bigint
#  user_id     :integer
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  diagcode_id :integer
#  pss_code    :string
#  who_code    :string
#  result      :string
#  cyto_status :string
#
class Diagnostic < ApplicationRecord
  belongs_to :inform

  has_many :objections, as: :objectionable, dependent: :destroy
  belongs_to :diagcode

  default_scope -> { order(created_at: :asc) }

  # validates :description, presence: true
  
end
