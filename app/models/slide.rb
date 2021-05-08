# == Schema Information
#
# Table name: slides
#
#  id          :bigint           not null, primary key
#  inform_id   :bigint
#  user_id     :integer
#  slide_tag   :string
#  stored      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#  colored     :boolean          default(FALSE)
#  tagged      :boolean          default(FALSE)
#  covered     :boolean          default(FALSE)
#
class Slide < ApplicationRecord
  belongs_to :inform

  has_many :objections, as: :objectionable, dependent: :destroy
  # has_many :objections, as: :objectionable

  default_scope -> { order(slide_tag: :asc) }
end
