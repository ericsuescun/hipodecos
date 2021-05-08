# == Schema Information
#
# Table name: micros
#
#  id          :bigint           not null, primary key
#  inform_id   :bigint
#  user_id     :integer
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  cyto_status :string
#
class Micro < ApplicationRecord
  belongs_to :inform

  has_many :objections, as: :objectionable, dependent: :destroy
  # has_many :objections, as: :objectionable

  has_many :pictures, as: :imageable, dependent: :destroy
  # has_many :pictures, as: :imageable

  default_scope -> { order(created_at: :asc) }

  validates :description, presence: true
end
