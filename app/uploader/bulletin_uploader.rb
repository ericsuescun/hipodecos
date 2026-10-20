# Boletín shown on the public "Seguridad del paciente" page. Not mounted on any
# model: there is a single file at a fixed path, and each upload overwrites it.
class BulletinUploader < CarrierWave::Uploader::Base
  FILENAME = "boletin.jpg"

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  def store_dir
    "uploads/bulletin"
  end

  def filename
    FILENAME if original_filename
  end

  # Stored as-is (no resize): bulletins are designed graphics with text that
  # must stay legible.
  def extension_allowlist
    %w(jpg jpeg png gif)
  end

  def size_range
    0..10.megabytes
  end

  # The URL never changes, so make browsers revalidate instead of showing a
  # stale bulletin after a new upload.
  def fog_attributes
    { 'Cache-Control' => 'no-cache' }
  end

  # URL of the uploaded bulletin, or nil if none has been uploaded yet.
  def self.current_url
    uploader = new
    uploader.retrieve_from_store!(FILENAME)
    uploader.url if uploader.file.exists?
  end
end
