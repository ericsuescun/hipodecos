# == Schema Information
#
# Table name: cytologies
#
#  id            :bigint           not null, primary key
#  inform_id     :bigint
#  pregnancies   :integer
#  last_mens     :string
#  prev_appo     :string
#  sample_date   :date
#  last_result   :string
#  birth_control :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer
#  suggestion    :text
#
class Cytology < ApplicationRecord
  belongs_to :inform, optional: true

  has_many :objections, as: :objectionable, dependent: :destroy
  
end
