# == Schema Information
#
# Table name: factors
#
#  id          :bigint           not null, primary key
#  codeval_id  :bigint
#  rate_id     :bigint
#  factor      :decimal(, )
#  description :text
#  admin_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  cost_id     :integer
#  price       :decimal(, )
#
class Factor < ApplicationRecord
  belongs_to :codeval
  belongs_to :rate

  validates :description, presence: true
end
