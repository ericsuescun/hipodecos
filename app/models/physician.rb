# == Schema Information
#
# Table name: physicians
#
#  id         :bigint           not null, primary key
#  inform_id  :bigint
#  user_id    :integer
#  name       :string
#  lastname   :string
#  tel        :string
#  cel        :string
#  email      :string
#  study1     :string
#  study2     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Physician < ApplicationRecord
  belongs_to :inform, optional: true

  # has_many :objections, as: :objectionable
  has_many :objections, as: :objectionable, dependent: :destroy

  # validates :name, :lastname, presence: true
  before_save { self.name.upcase! }
  before_save { self.lastname.upcase! }

end
