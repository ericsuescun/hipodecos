# == Schema Information
#
# Table name: studies
#
#  id                :bigint           not null, primary key
#  inform_id         :bigint
#  user_id           :integer
#  codeval_id        :integer
#  factor            :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  cost              :decimal(, )
#  price             :decimal(, )
#  margin            :decimal(, )
#  price_description :text
#
class Study < ApplicationRecord
  belongs_to :inform

  has_many :objections, as: :objectionable, dependent: :destroy
  # has_many :objections, as: :objectionable

  default_scope -> { order(created_at: :asc) }

  validates :codeval_id, :factor, presence: true
end
