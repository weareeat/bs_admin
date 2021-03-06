class BsAdmin::ImageSettingUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  storage :file
  process :resize_to_limit => [2000, 2000]

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process :resize_to_fit => [180, 250]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
