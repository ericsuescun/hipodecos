# == Schema Information
#
# Table name: samples
#
#  id            :bigint           not null, primary key
#  inform_id     :bigint
#  user_id       :integer
#  name          :string
#  description   :text
#  recipient_tag :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  sample_tag    :string
#  organ_code    :string
#  fragment      :integer
#  slide_tag     :string
#  included      :boolean          default(FALSE)
#  blocked       :boolean          default(FALSE)
#
class Sample < ApplicationRecord
  belongs_to :inform

  default_scope -> { order(sample_tag: :asc) }

  scope :with_cassette, -> { where(name: "Cassette") }
  scope :included, -> { where(included: true) }
  scope :not_included, -> { where(included: false) }
  scope :blocked, -> { where(blocked: true) }
  scope :not_blocked, -> { where(not_blocked: false) }

  has_many :objections, as: :objectionable, dependent: :destroy
  # has_many :objections, as: :objectionable

  has_many :pictures, as: :imageable, dependent: :destroy
  # has_many :pictures, as: :imageable

  default_scope -> { order(created_at: :asc) }

  validates :sample_tag, presence: true
end
