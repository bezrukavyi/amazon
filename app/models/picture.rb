class Picture < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  mount_uploader :path, ImageUploader
end
