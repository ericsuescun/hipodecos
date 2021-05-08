# == Schema Information
#
# Table name: scripts
#
#  id           :bigint           not null, primary key
#  automatic_id :bigint
#  script_type  :string
#  description  :text
#  organ        :string
#  param1       :integer
#  param2       :integer
#  script_order :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#  diagnostic   :text
#  pss_code     :string
#  who_code     :string
#  suggestion   :text
#
class Script < ApplicationRecord
  belongs_to :automatic

  default_scope -> { order(script_order: :asc) }
end
