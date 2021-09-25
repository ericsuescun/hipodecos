# == Schema Information
#
# Table name: blocks
#
#  id          :bigint           not null, primary key
#  inform_id   :bigint
#  user_id     :integer
#  block_tag   :string
#  stored      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#  organ_code  :string
#  fragment    :integer
#  slide_tag   :string
#  verified    :boolean          default(FALSE)
#
class Block < ApplicationRecord
  belongs_to :inform

  has_many :objections, as: :objectionable, dependent: :destroy
  # has_many :objections, as: :objectionable

  has_one :sample, class_name: 'Sample', primary_key: 'block_tag', foreign_key: 'sample_tag'

  default_scope -> { order(block_tag: :asc) }
  scope :verified, -> { where(verified: true) }
  scope :not_verified, -> { where(verified: false) }
  scope :slided, -> { where.not(slide_tag: nil) }
  scope :not_slided, -> { where(slide_tag: nil) }
  
  validates :block_tag, uniqueness: true
end
