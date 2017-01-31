class Picture < ApplicationRecord
  mount_uploader :path, ImageUploader

  belongs_to :imageable, polymorphic: true
end
