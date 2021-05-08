# == Schema Information
#
# Table name: recipients
#
#  id          :bigint           not null, primary key
#  inform_id   :bigint
#  user_id     :integer
#  tag         :string
#  description :text
#  samples     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Recipient < ApplicationRecord
  belongs_to :inform

  default_scope -> { order(tag: :asc)}

  # has_many :objections, as: :objectionable
  has_many :objections, as: :objectionable, dependent: :destroy
end
