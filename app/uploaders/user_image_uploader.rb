# encoding: utf-8
#

class UserImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick

  # Override the directory where uploaded files will be stored.
  def store_dir
    "users/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    '/assets/fallback/' + [version_name, 'user.png'].compact.join('_')
  end

  # Create different versions of your uploaded files:
  version :list do
    process :scale => [50, 50]
  end
  version :small do
    process :scale => [30, 30]
  end
  version :header do
    process :scale => [40, 40]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(jpg jpeg gif png)
  end
  
end
