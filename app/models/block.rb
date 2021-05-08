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

  default_scope -> { order(block_tag: :asc) }
  
  validates :block_tag, uniqueness: true
end
