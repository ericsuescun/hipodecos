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
