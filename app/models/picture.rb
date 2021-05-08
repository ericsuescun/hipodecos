# == Schema Information
#
# Table name: pictures
#
#  id             :bigint           not null, primary key
#  imageable_type :string
#  imageable_id   :bigint
#  user_id        :integer
#  name           :string
#  description    :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Picture < ApplicationRecord
  belongs_to :imageable, polymorphic: true

  mount_uploader :name, PictureUploader

  validate  :image_size

  private

    # Validates the size of an uploaded picture.
    def image_size
      if name.size > 10.megabytes
        errors.add(:name, "Debe ser menor a 10MB")
      end
    end
    
end
