class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    'fallback/' + [version_name, "default_#{model.class.to_s.downcase}.png"]
                  .compact.join('_')
  end

  version :thumb do
    process resize_to_fill: [400, 300]
  end

  version :small do
    process resize_to_fill: [200, 150]
  end

  def extension_white_list
    %w(jpg jpeg png)
  end
end
