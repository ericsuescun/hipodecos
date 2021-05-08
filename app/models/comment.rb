# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  commentable_type :string
#  commentable_id   :bigint
#  user_id          :integer
#  title            :string
#  body             :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true
end
