# == Schema Information
#
# Table name: objections
#
#  id                  :bigint           not null, primary key
#  objectionable_type  :string
#  objectionable_id    :bigint
#  user_id             :integer
#  obcode_id           :integer
#  responsible_user_id :integer
#  close_user_id       :integer
#  close_date          :date
#  description         :text
#  closed              :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class Objection < ApplicationRecord
  belongs_to :objectionable, polymorphic: true

  default_scope -> { order(closed: :asc, created_at: :desc) }

  validates :obcode_id, presence: true
end
